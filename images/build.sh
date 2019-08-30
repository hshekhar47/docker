BUILD_HOME_DIR=$(dirname "$(readlink -fm "$0")")

ARG_SRC_PATH=""
ARG_TAG=""
ARG_VERSION=""

source ${BUILD_HOME_DIR}/scripts/env.sh --source-only
source ${BUILD_HOME_DIR}/scripts/core.sh --source-only

function infer_build_tag_from_src_path() {
    tag_name=$(basename $ARG_SRC_PATH)
    echo ${tag_name#"hs-"}
}

function build_image() {
    build_cmd="docker build "
    if [[ ! -z "${ARG_TAG}" ]]; then 
        build_cmd="${build_cmd} -t ${DEFAULT_IMAGE_GROUP}/${ARG_TAG}:${DEFAULT_IMAGE_VERSION}"; 
    else
        ARG_TAG=$(infer_build_tag_from_src_path)
        build_cmd="${build_cmd} -t ${DEFAULT_IMAGE_GROUP}/${ARG_TAG}:${DEFAULT_IMAGE_VERSION}"
    fi
    if [[ ! -z "${ARG_VERSION}" ]]; then 
        build_cmd="${build_cmd} -t ${DEFAULT_IMAGE_GROUP}/${ARG_TAG}:${ARG_VERSION}"; 
    fi

    build_cmd="${build_cmd} ${ARG_SRC_PATH}"
    log_info "executing: ${build_cmd}"
    eval "$build_cmd"
}

function usage_details() {
    script_name=`basename "$0"`
    echo "[Usage] ${script_name} <image_src_dir>"
    echo "[Options]"
    echo "--label      label of the image"
    echo "--version    version of the image"
    echo ""
    echo "example:"
    echo "${script_name} core/debian --tag=debian --version=latest"
}

if [[ $# -lt 1 ]]; then
    log_error "Invalid invocation, Please see the usage below"
    usage_details
    exit 1;
fi

if [[ -d "${BUILD_HOME_DIR}/${1}" ]]; then
    ARG_SRC_PATH=${BUILD_HOME_DIR}/${1}
    log_info "ARG_SRC_PATH=${ARG_SRC_PATH}"
    shift
else
    log_error "Invalid path ${BUILD_HOME_DIR}/${1}"
fi

while test $# -gt 0
do
    key=`echo "$1" | cut -d'=' -f 1`
    value=`echo "$1" | cut -d'=' -f 2`
    #debug "Key = $key , Value = $value"
    case "$key" in
        --label)
                ARG_TAG=$value
                echo "Setting label=${ARG_TAG}";
            ;;
        --version)
                ARG_VERSION=$value
                echo "Setting version=${ARG_VERSION}"
            ;;
        *)
            log_error "Invalid arguments, Please see the usage below"
            usage_details
            exit 1;
            ;;
    esac
    shift
done

build_image


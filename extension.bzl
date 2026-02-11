load("//container:pull.bzl", "container_pull_attrs", "container_pull")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(
    "@io_bazel_rules_docker//toolchains/docker:toolchain.bzl",
    _docker_toolchain_configure = "toolchain_configure",
)

def _docker_impl(module_ctx):
    deps = []
    for module in module_ctx.modules:
        if module.is_root:
            for tag in module.tags.docker_toolchain_configure:
                _docker_toolchain_configure(name = tag.repo_name)
                deps.append(tag.repo_name)
    return module_ctx.extension_metadata(
        reproducible = True,
        root_module_direct_deps = deps,
        root_module_direct_dev_deps = [],
    )

docker = module_extension(
    implementation = _docker_impl,
    tag_classes = {
        "docker_toolchain_configure": tag_class(
            attrs = {
                "repo_name": attr.string(),
            },
        ),
    },
)

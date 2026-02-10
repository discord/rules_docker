load("//container:pull.bzl", "container_pull_attrs", "container_pull")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(
    "@io_bazel_rules_docker//toolchains/docker:toolchain.bzl",
    _docker_toolchain_configure = "toolchain_configure",
)

def _cc_images(): pass
def _py_images(): pass
def _py3_images(): pass
def _scala_images(): pass
def _java_images(): pass

def _docker_impl(module_ctx):
    for module in module_ctx.modules:
        for tag in module.tags.container_pull:
            container_attrs = dicts.add({"name": tag.repo_name}, container_attrs)
            for key in container_pull_attrs:
                container_attrs[key] = getattr(tag, key)
            container_pull(**container_attrs)
        for tag in module.tags.docker_toolchain_configure:
            _docker_toolchain_configure(name = tag.repo_name)
        for tag in module.tags.cc_images:
            _cc_images()
        for tag in module.tags.py_images:
            _py_images()
        for tag in module.tags.py3_images:
            _py3_images()
        for tag in module.tags.scala_images:
            _scala_images()
        for tag in module.tags.java_images:
            _java_images()

docker = module_extension(
    implementation = _docker_impl,
    tag_classes = {
        "container_pull": tag_class(
            attrs = dicts.add({"repo_name": attr.string()}, container_pull_attrs)
        ),
        "docker_toolchain_configure": tag_class(
            attrs = {
                "repo_name": attr.string(),
            },
        ),
        # TODO: These may not actually be necessary, and might have been leftover
        #       transitive ways to get e.g. go_repository rules and gazell deps
        #       into the global context.
        "cc_images": tag_class(attrs = {}),
        "py_images": tag_class(attrs = {}),
        "py3_images": tag_class(attrs = {}),
        "scala_images": tag_class(attrs = {}),
        "java_images": tag_class(attrs = {}),
    },
)

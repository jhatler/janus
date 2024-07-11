terraform {
  before_hook "kernel_repository" {
    commands     = ["apply", "plan", "init"]
    execute      = ["sh", "-c", "sed -i 's|$KERNEL_REPOSITORY|${get_env("TF_VAR_kernel_repository")}|g' *.tf" ]
  }

  before_hook "kernel_registry" {
    commands     = ["apply", "plan", "init"]
    execute      = ["sh", "-c", "sed -i 's|$KERNEL_REGISTRY|${get_env("TF_VAR_kernel_registry")}|g' *.tf" ]
  }

  before_hook "kernel_namespace" {
    commands     = ["apply", "plan", "init"]
    execute      = ["sh", "-c", "sed -i 's|$KERNEL_NAMESPACE|${get_env("TF_VAR_kernel_namespace")}|g' *.tf" ]
  }
}

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_artifactory"></a> [artifactory](#requirement\_artifactory) | 12.3.1 |
| <a name="requirement_project"></a> [project](#requirement\_project) | 1.9.0 |
| <a name="requirement_xray"></a> [xray](#requirement\_xray) | 2.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_artifactory"></a> [artifactory](#provider\_artifactory) | 12.3.1 |
| <a name="provider_project"></a> [project](#provider\_project) | 1.9.0 |
| <a name="provider_xray"></a> [xray](#provider\_xray) | 2.13.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [artifactory_local_docker_v2_repository.docker_dev_local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_docker_v2_repository) | resource |
| [artifactory_local_docker_v2_repository.docker_prod_local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_docker_v2_repository) | resource |
| [artifactory_local_docker_v2_repository.docker_rc_local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_docker_v2_repository) | resource |
| [artifactory_local_gradle_repository.gradle-dev-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_gradle_repository) | resource |
| [artifactory_local_gradle_repository.gradle-prod-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_gradle_repository) | resource |
| [artifactory_local_gradle_repository.gradle-rc-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_gradle_repository) | resource |
| [artifactory_local_helm_repository.helm-dev-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_helm_repository) | resource |
| [artifactory_local_helm_repository.helm-prod-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_helm_repository) | resource |
| [artifactory_local_helm_repository.helm-rc-local](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/local_helm_repository) | resource |
| [artifactory_remote_docker_repository.docker-remote](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/remote_docker_repository) | resource |
| [artifactory_remote_generic_repository.generic-remote](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/remote_generic_repository) | resource |
| [artifactory_remote_gradle_repository.gradle-remote](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/remote_gradle_repository) | resource |
| [artifactory_remote_helm_repository.helm-remote](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/remote_helm_repository) | resource |
| [artifactory_virtual_docker_repository.docker-virtual](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/virtual_docker_repository) | resource |
| [artifactory_virtual_gradle_repository.gradle-virtual](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/virtual_gradle_repository) | resource |
| [artifactory_virtual_helm_repository.helm-virtual](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/virtual_helm_repository) | resource |
| [project_project.this](https://registry.terraform.io/providers/jfrog/project/1.9.0/docs/resources/project) | resource |
| [xray_security_policy.min_critical](https://registry.terraform.io/providers/jfrog/xray/2.13.0/docs/resources/security_policy) | resource |
| [xray_watch.watch](https://registry.terraform.io/providers/jfrog/xray/2.13.0/docs/resources/watch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the JFrog Project | `string` | `"Student Project"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the JFrog Project | `string` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Key of the JFrog Project | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
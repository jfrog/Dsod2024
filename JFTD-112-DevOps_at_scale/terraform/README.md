# Infrastructure deployment

This Terraform stack deploy JFrog Project with all local, remote and virtual repositories for the labs. It also includes Xray watches and polcies and IAM users.

## Pre-requisites

You need to install terraform. To check the terraform installation, run :


        terraform --version


## terraform.tfvars

The *terraform.tfvars* file has been ignored by git because it contains secrets (default password and access tokens).

Before running the stack please create it as follows (feel free to tune it):

        jfrog_url = "https://dsodmultisite.jfrog.io"
        access_token = "<ADMIN_TOKEN>"

        projects = [
            {
                project_key = "stdy"
                display_name = "Student Y"
            },
            {
                project_key = "stdz"
                display_name = "Student Z"
            }
        ]
        
        temporary_password = "JFrogDSODEvent2024!"
        paring_token_edge_aus = ""

        pairing_token_edge_hk = ""

        pairing_token_secondary_jpd = ""

## Working with Terraform

The backend of this stack is on another JPD. Before deploying, please authenticate on these platform with: 

        terraform login <PLATFORM_URL>

To deploy the stack :

        terraform init
        terraform apply

To remove the stack :

        terraform destroy

Some resources like *missioncontrol_access_federation_mesh* cannot be destroyed using API as documented [here](https://registry.terraform.io/providers/jfrog/mission-control/latest/docs/resources/access_federation_mesh). Therefore, you need to use the UI



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_artifactory"></a> [artifactory](#requirement\_artifactory) | 12.3.1 |
| <a name="requirement_missioncontrol"></a> [missioncontrol](#requirement\_missioncontrol) | 1.1.0 |
| <a name="requirement_project"></a> [project](#requirement\_project) | 1.9.0 |
| <a name="requirement_xray"></a> [xray](#requirement\_xray) | 2.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_artifactory"></a> [artifactory](#provider\_artifactory) | 12.3.1 |
| <a name="provider_missioncontrol"></a> [missioncontrol](#provider\_missioncontrol) | 1.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_project"></a> [project](#module\_project) | ./modules/student-workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [artifactory_user.users](https://registry.terraform.io/providers/jfrog/artifactory/12.3.1/docs/resources/user) | resource |
| [missioncontrol_access_federation_mesh.mesh-topology](https://registry.terraform.io/providers/jfrog/mission-control/1.1.0/docs/resources/access_federation_mesh) | resource |
| [missioncontrol_jpd.dsodedgeaus](https://registry.terraform.io/providers/jfrog/mission-control/1.1.0/docs/resources/jpd) | resource |
| [missioncontrol_jpd.dsodedgehk](https://registry.terraform.io/providers/jfrog/mission-control/1.1.0/docs/resources/jpd) | resource |
| [missioncontrol_jpd.dsodmultisite2](https://registry.terraform.io/providers/jfrog/mission-control/1.1.0/docs/resources/jpd) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token"></a> [access\_token](#input\_access\_token) | JFrog access token to deploy infrastructure | `string` | n/a | yes |
| <a name="input_jfrog_url"></a> [jfrog\_url](#input\_jfrog\_url) | URL of the JFrog platform | `string` | n/a | yes |
| <a name="input_pairing_token_edge_hk"></a> [pairing\_token\_edge\_hk](#input\_pairing\_token\_edge\_hk) | Temporary paring token | `string` | n/a | yes |
| <a name="input_pairing_token_secondary_jpd"></a> [pairing\_token\_secondary\_jpd](#input\_pairing\_token\_secondary\_jpd) | Temporary paring token | `string` | n/a | yes |
| <a name="input_paring_token_edge_aus"></a> [paring\_token\_edge\_aus](#input\_paring\_token\_edge\_aus) | Temporary paring token | `string` | n/a | yes |
| <a name="input_projects"></a> [projects](#input\_projects) | List of JFrog project to create for students | <pre>list(<br/>    object({<br/>      project_key = string<br/>      display_name = string<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_temporary_password"></a> [temporary\_password](#input\_temporary\_password) | Temporary password for users | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
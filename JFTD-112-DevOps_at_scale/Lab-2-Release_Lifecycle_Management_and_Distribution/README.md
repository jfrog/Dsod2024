# LAB 2 - Release Lifecycle Management and Distribution

The aim of this lab is to ...

## Lab Architecture

![Architecture](./assets/lab2_architecture.png)

This lab is composed of:

- Main JPD platform (with Mission Control enabled) in Ireland (https://dsodmultisite.jfrog.io/)
- Second JPD in N. Virginia (https://dsodmultisite2.jfrog.io/)
- Artifactory Edge node in Hong Kong (https://dsodedgehk.jfrog.io/)
- Artifactory Edge node in Australia (https://dsodedgeaus.jfrog.io/)

All these resources are part of the same circle of trust and access are federated between them (users, groups and tokens).

For this lab, you will use the following resources (already created):

Virtual repositories:
- <PROJECT_KEY>-app-docker-virtual
- <PROJECT_KEY>-app-gradle-virtual
- <PROJECT_KEY>-app-helm-virtual

Local repositories:
- <PROJECT_KEY>-app-docker-dev-local
- <PROJECT_KEY>-app-docker-rc-local
- <PROJECT_KEY>-app-docker-prod-local
- <PROJECT_KEY>-app-gradle-dev-local
- <PROJECT_KEY>-app-gradle-rc-local
- <PROJECT_KEY>-app-gradle-prod-local
- <PROJECT_KEY>-app-helm-dev-local
- <PROJECT_KEY>-app-helm-rc-local
- <PROJECT_KEY>-app-helm-prod-local

Remote repositories
- <PROJECT_KEY>-app-docker-remote
- <PROJECT_KEY>-app-gradle-remote
- <PROJECT_KEY>-app-helm-remote

One build-info repository with 3 builds (on per package type) and one release-bundle-v2 


![Lab resources](./assets/lab2_resources.png)

## Release lifecycle management

In this section, we are going to create a release bundle from à build-info. 

1. From the **Application** module, select **Builds** then *<PROJECT_KEY>-maven-build*. 
![Build select](./assets/lab2_select_build.png)
2. Choose the build ID *1* and then create a release bundle from it (You can optionally browse the build info to understand its value). 
![Create RBV2](./assets/create_rbv2_from_build.png)
3. Enter a name and version for your release. Select the *LoadDeptKey* as signing key and press Next
![RBV2 Creation](./assets/lab2_rbv2_creation.png)
4. You can see all artifact that will be included in the release bundle. **Do not include dependencies for now** and press Create
![RBV2 Dependencies](./assets/lab2_rbv2_dependencies.png)
5. Your release bundle has been created. If you click on the release bundle version then *create* event, you can see the content of this release
![RBV2 Content](./assets/lab2_rbv2_content.png)
6. Close this window and come back to the release bundle version. You can now drag and drop the release bundle version from **NEW** environment to **DEV** environment.
![RBV2 Promotion Content](./assets/lab2_promotion_content.png)
7. You are about to promote your release bundle in the dev environment. Click on next then you will see the target repository for the promotion. Finaly promote your release bundle
![RBV2 Promote Dev](./assets/lab2_promote_to_dev.png)
8. You are successfully promoted your bundle to the development environment. You can now do the same steps to promote it to **STG** then **PROD**
![RBV2 Promoted](./assets/lab2_rbv2_promoted.png)
9. [Optional] You can check after a promotion that artifacts have been copied to the STG and PROD local repository
![RBV2 Copied](./assets/lab2_artifact_copied.png)
10. Come back to your release bundle and click on the latest version created. Your artifact is ready for production and distribution. Click on **Actions** then **distribute**
![RBV2 Start Distribution](./assets/lab2_start_distribution.png)
11. Select the edge where you want to distribute your release bundle (You can optionally create the repository if it does not exist on the Edge node).
![Select Edge](./assets/lab2_select_edge.png)
12. Click on *Next* then *Distribute*
13. You should now see that your distribution is in progress then distributed
![Distrib](./assets/lab2_distrib_in_progress.png)
![Distrib Done](./assets/lab2_distrib_done.png)
14. [Optional] You can review all evidences related to a release bundle 
15. Check on the edge node you selected that your artifact has been distributed. 
![Check Distrib](./assets/lab2_check_distrib.png)

**Note**: <br>
As you can see, there is no JFrog project on the Edge nodes. In additional, the repository which has been created automatically is not the production repository but dev one. This is a limitation of the feature "Auto create missing repositories"

### Going further

Watch & Policy with "Block promotion" and "Block distribution" ?

# Congratulations ! You have completed Lab

## API commands
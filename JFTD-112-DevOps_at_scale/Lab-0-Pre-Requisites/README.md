# Lab 0 - Pre-requisites

The aim of this lab is to configure the JFrog CLI / cURL client for students that want to interact programmatically with the JFrog platform. This lab is optional since every action can be done with the UI.

## Configure JFrog CLI

1. Download the [JFrog CLI](https://jfrog.com/getcli/)
2. Check CLI installation


      jf --version

3. Configure CLI to point to your JFrog Instance


      jf config add --interactive


- Default-Server: dsod
- JFrog Platform URL : https://dsodmultisite.jfrog.io/
- Authentication method : Username / password (you can also use Access Token but you must create it before)
- Artifactory reserve proxy : N

4. Use the newly created configi


      jf config use dsod

5. Check the configuration


      jf rt ping


(JFrog CLI for Artifactory documentation)(https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/cli-for-jfrog-artifactory)


## REST API with cURL client

Export your username and password in an environment variable (choose either username/password or token)


    export CREDS=username:password
    OR 
    export TOKEN=<TOKEN>
    export JFROG_URL=https://dsodmultisite.jfrog.io


Request Artifactory health check


    curl -u $CREDS "$JFROG_URL/artifactory/api/system/ping"
    curl -H "Authorization: Bearer $TOKEN" "$JFROG_URL/artifactory/api/system/ping"




# Congratulations ! You have completed Lab 0

mvn -DskipTests=true clean package

# deploy the app
cf push -b java_buildpack --health-check-type none -p target/demo-0.0.1-SNAPSHOT.jar runner
cf cs scheduler-for-pcf standard scheduler-joshlong
cf bs runner scheduler-joshlong
cf restage runner

# deploy the job
cf create-job runner my-job ".java-buildpack/open_jdk_jre/bin/java org.springframework.boot.loader.JarLauncher"
cf run-job my-job
cf schedule-job my-job "* * ? * *"

# Cloudfoundry Task Demo

This demonstrates how to run a Spring Cloudd Task-based application on Cloud Foundry (including on Pivotal Web Services) [as a task](http://docs.pivotal.io/pcf-scheduler/1-1/using-jobs.html).

Build the application.

```
mvn -DskipTests=true clean package
```

Deploy the Spring Cloud Task-based application to the platform. This is a Spring Cloud Task-based application. It has no web endpoint. The platform's health check will try to ascertain the health of the application by checking whether it's responding to an HTTP request. We could also test that the application is bound to a non-HTTP port. Neither apply here, though. This task will start and then stop. So, when you deploy it make sure that there is no health-check specified.


```
cf push --health-check-type none -p demo-0.0.1-SNAPSHOT.jar runner
```

Runs the task using the Task runner. This support for tasks is built into the platform.

```
cf run-task runner ".java-buildpack/open_jdk_jre/bin/java org.springframework.boot.loader.JarLauncher" --name my-task
```

You can schedule tasks using the PCS job scheduler. Create a new instance of the schduler service, as you would normally:

```
cf cs scheduler-for-pcf standard scheduler-joshlong
```

and then bind the service to the task.

```
cf bs runner scheduler-joshlong
```

Once you have the scheduler installed, you'll need [the Pivotal Cloud Foundry job scheduler plugin for the `cf` CLI](https://network.pivotal.io/products/p-scheduler-for-pcf). Once the `cf` CLI plugin is installed, you can create jobs.

```
cf create-job runner my-job ".java-buildpack/open_jdk_jre/bin/java org.springframework.boot.loader.JarLauncher"
```

You can run a job manually to verify the job configuration is working:

```
cf run-job my-job
```

You can schedule the job using a CRON expression of the following form: `MIN HOUR DAY-OF-MONTH MONTH DAY-OF-WEEK`.

```
cf schedule-job my-job "* * ? * *"
```

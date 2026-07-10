# Getting Started

## Prerequisites

- Java 17+ installed
- Maven installed
- Internet access to reach MongoDB Atlas

## Run Backend

1. Open a terminal in the `backend` folder.

```powershell
cd "C:\path\to\keliri-main\backend"
```

2. Add Maven to `PATH` for the current terminal.

```powershell
$env:PATH += ";C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.14\bin"
```

3. Start the backend on port `3000`.

```powershell
mvn spring-boot:run '-Dspring-boot.run.jvmArguments=-Dserver.port=3000'
```

4. Verify the backend is running.

Open:

```text
http://localhost:3000/api/health/check
```

Expected response:

```text
MongoDB connection is successful
```

## Notes

- MongoDB is currently configured through [application.properties](/abs/path/C:/Users/preeti%20yadav/Downloads/keliri-main%20(1)/keliri-main/backend/src/main/resources/application.properties:1).
- If port `3000` is busy, change the port value in the Maven run command.

## Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/3.3.2/maven-plugin)
* [Create an OCI image](https://docs.spring.io/spring-boot/3.3.2/maven-plugin/build-image.html)
* [Spring Data MongoDB](https://docs.spring.io/spring-boot/docs/3.3.2/reference/htmlsingle/index.html#data.nosql.mongodb)
* [Spring Web](https://docs.spring.io/spring-boot/docs/3.3.2/reference/htmlsingle/index.html#web)
* [Spring Web Services](https://docs.spring.io/spring-boot/docs/3.3.2/reference/htmlsingle/index.html#io.webservices)

### Guides
The following guides illustrate how to use some features concretely:

* [Accessing Data with MongoDB](https://spring.io/guides/gs/accessing-data-mongodb/)
* [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/)
* [Serving Web Content with Spring MVC](https://spring.io/guides/gs/serving-web-content/)
* [Building REST services with Spring](https://spring.io/guides/tutorials/rest/)
* [Producing a SOAP web service](https://spring.io/guides/gs/producing-web-service/)

### Maven Parent overrides

Due to Maven's design, elements are inherited from the parent POM to the project POM.
While most of the inheritance is fine, it also inherits unwanted elements like `<license>` and `<developers>` from the parent.
To prevent this, the project POM contains empty overrides for these elements.
If you manually switch to a different parent and actually want the inheritance, you need to remove those overrides.

package com.istio.meshlab.api;

import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
class GreetingResourceTest {

    @Inject
    @ConfigProperty(name = "meshlab.service.name")
    String serviceName;

    @Test
    void testHelloEndpoint() {
        given()
          .when().get("/api/greeting/hello")
          .then()
             .statusCode(200)
             .body(is("Hello from " + serviceName));
    }

}
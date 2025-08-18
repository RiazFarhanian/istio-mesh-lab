package com.istio.meshlab.api;

import com.istio.meshlab.client.ClientService;
import io.quarkus.test.InjectMock;
import io.quarkus.test.junit.QuarkusTest;
import jakarta.inject.Inject;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.mockito.Mockito.when;

@QuarkusTest
class ClientResourceTest {
    @Inject
    @ConfigProperty(name = "meshlab.service.name")
    String serviceName;

    @InjectMock
    @RestClient
    ClientService clientService;


    @Test
    void testHelloEndpoint() {
        when(clientService.helloClient())
                .thenReturn("Hello from " + serviceName);

        given()
                .when().get("/api/client/hello")
                .then()
                .statusCode(200)
                .body(is("Client respond: Hello from " + serviceName));
    }
}
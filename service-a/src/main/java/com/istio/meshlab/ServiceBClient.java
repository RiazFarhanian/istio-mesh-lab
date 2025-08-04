package com.istio.meshlab;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/hello")
@RegisterRestClient(configKey = "service-b-api")
public interface ServiceBClient {
    @GET
    String hello();
}

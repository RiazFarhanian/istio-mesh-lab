package com.istio.meshlab;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/call-b")
public class ServiceAResource {

    @Inject
    @RestClient
    ServiceBClient serviceBClient;

    @GET
    public String callB() {
        return "Service A invoking Service B. Response is: " + serviceBClient.hello();
    }
}
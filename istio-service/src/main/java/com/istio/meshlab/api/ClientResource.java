package com.istio.meshlab.api;

import com.istio.meshlab.client.ClientService;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/api/client")
public class ClientResource
{
    @RestClient
    ClientService clientService;

    @GET
    @Path("/hello")
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Client respond: " + clientService.helloClient();
    }

}
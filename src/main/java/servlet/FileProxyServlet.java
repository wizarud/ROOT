package servlet;

import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Set;

import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/proxy")
public class FileProxyServlet extends HttpServlet {

    private static final Set<String> ALLOWED_HOSTS = Set.of(
            "advisor",
            "localhost"
    );

    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        String urlParam = req.getParameter("url");

        if (urlParam == null || urlParam.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            URI uri = URI.create(urlParam);
            
            System.out.println(uri.getHost());
            
            // --- security checks ---
            if (!"http".equalsIgnoreCase(uri.getScheme()) &&
                !"https".equalsIgnoreCase(uri.getScheme())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            if (uri.getHost()!=null) {
                if (!ALLOWED_HOSTS.contains(uri.getHost())) {
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }            	
            }

            // --- call remote server ---
            HttpRequest request = HttpRequest.newBuilder(uri).GET().build();

            HttpResponse<InputStream> response =
                    client.send(request, HttpResponse.BodyHandlers.ofInputStream());

            resp.setStatus(response.statusCode());

            // copy headers
            response.headers().firstValue("Content-Type")
                    .ifPresent(resp::setContentType);

            response.headers().firstValue("Content-Length")
                    .ifPresent(len -> resp.setHeader("Content-Length", len));

            // --- stream body ---
            try (InputStream in = response.body();
                 ServletOutputStream out = resp.getOutputStream()) {

                byte[] buffer = new byte[1024 * 1024 * 5];
                int read;

                while ((read = in.read(buffer)) != -1) {
                    out.write(buffer, 0, read);
                }
            }

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            throw new RuntimeException(e);
        }
    }
}

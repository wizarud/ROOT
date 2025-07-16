package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wayos.Configuration;
import com.wayos.servlet.console.ConsoleServlet;

@WebServlet("/th")
public class THServlet extends ConsoleServlet {
	
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String contextRoot = req.getContextPath();
				
		String contextRootURL = Configuration.domain + contextRoot;
		
		resp.sendRedirect(contextRootURL + "/x/eoss-th/web");
		
	}

}

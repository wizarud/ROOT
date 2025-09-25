package servlet.app;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wayos.servlet.PlayServlet;

@SuppressWarnings("serial")
@WebServlet("/joy/*")
public class JoyServlet extends PlayServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		super.doGet(req, resp);

		req.getRequestDispatcher("/app/joy/index.jsp").forward(req, resp);
	}
	
}

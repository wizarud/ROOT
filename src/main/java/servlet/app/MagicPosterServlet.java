package servlet.app;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wayos.Context;
import com.wayos.servlet.PlayServlet;
import com.wayos.servlet.console.ConsoleServlet;

import x.org.json.JSONObject;

@SuppressWarnings("serial")
@WebServlet("/magic/*")
public class MagicPosterServlet extends PlayServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		super.doGet(req, resp);

		req.getRequestDispatcher("/app/magicposter/index.jsp").forward(req, resp);
	}
	
}

package servlet;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.client.j2se.MatrixToImageWriter;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/qrcode")
public class QRCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get text parameter from URL (e.g. /qrcode?text=HelloWorld)
        String text = request.getParameter("text");
        if (text == null || text.isEmpty()) {
            text = "Default QR Code Content";
        }

        int size = 500; // width and height
        QRCodeWriter qrCodeWriter = new QRCodeWriter();

        try {
            BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, size, size);

            response.setContentType("image/png");
            OutputStream out = response.getOutputStream();

            // Write the QR image directly to servlet output stream
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", out);

            out.flush();
            out.close();
        } catch (WriterException e) {
            throw new ServletException("Error generating QR Code", e);
        }
    }
}


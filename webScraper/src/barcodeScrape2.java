package webscrape;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileOutputStream;
import java.io.IOException;

public class barcodeScrape2 {
    public static void main(String[] args)throws IOException {
        final String url = "https://www.upcitemdb.com/query?s=banana%20boat&type=2"; // Any url on upcitembd.com
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("Sheet 1");
        try {
            final Document document = Jsoup.connect(url).get();
            int count = 0;
            for (Element item : document.select("div.upclist.col-xs-12 ul li")) {
                Elements x = item.select("div.rImage");
                final String name = x.select("p").text();
                final String Tempbarcode = x.select("a").text();
                if(!Tempbarcode.equals("")) {
                    final double barcode = Double.parseDouble(Tempbarcode);
                    HSSFRow row = sheet.createRow(count);
                    HSSFCell cell1 = row.createCell(0);
                    HSSFCell cell2 = row.createCell(1);
                    cell1.setCellValue(barcode);
                    cell2.setCellValue(name);
                    count++;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        workbook.write(new FileOutputStream("bananaBoat.xls")); //title what you want the excel file to be called
        workbook.close();
    }
}

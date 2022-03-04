import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ExcelRead {

    private static final Map<String, String> lookup = new HashMap<>();
    private static final File file = new File("/Users/l0j04s4/github/java-utils/src/main/resources/ABBRV.XLS");

    private static final File inputFile = new File("/Users/l0j04s4/github/java-utils/src/main/resources/cust_orderitem.txt");
    private static final File outputFile = new File("/Users/l0j04s4/github/java-utils/src/main/resources/cust_orderitem_out.txt");

    public static void main(String[] args) throws BiffException, IOException {
        ExcelRead excelRead = new ExcelRead();
        excelRead.loadLookUp();
        excelRead.abbreviate();
    }

    public void loadLookUp() throws BiffException, IOException {
        Workbook wb = Workbook.getWorkbook(file);
        int sheets = wb.getNumberOfSheets();
        for (int i = 0; i < sheets; i++) {
            //Sheet sheet = wb.getSheet(i);
            Sheet sheet = wb.getSheet(i);
            int row = sheet.getRows();
            //int col = sheet.getColumns();
            for (int curRow = 0; curRow < row; curRow++) {
                Cell c1 = sheet.getCell(0, curRow);
                Cell c2 = sheet.getCell(1, curRow);
                if (c1.getContents().trim() == "") continue;
                //System.out.println(c1.getContents()+"->"+c2.getContents());
                lookup.put(c1.getContents().trim().toLowerCase(), c2.getContents().trim().toLowerCase());

                //System.out.println(lookup);
            }
        }
    }

    public void abbreviate() throws IOException {
        List<String> items;
        List<String> abbrList = new ArrayList<>();
        try (Stream<String> lines = Files.lines(Paths.get(inputFile.toURI()))) {
            items = lines.collect(Collectors.toList());
        }
        for (String item : items) {
            String[] splits = item.trim().split("_");
            StringBuilder sb = new StringBuilder();
            for (String split: splits) {
                sb.append(lookup.getOrDefault(split.trim().toLowerCase(),split)).append("_");
            }
            sb.deleteCharAt(sb.length()-1);
            abbrList.add(sb.toString());
        }
        Path out = Paths.get(outputFile.toURI());
        Files.deleteIfExists(out);
        Files.write(out,abbrList);
    }
}

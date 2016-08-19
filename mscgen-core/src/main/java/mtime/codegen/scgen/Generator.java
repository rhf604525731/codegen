package mtime.codegen.scgen;

import mtime.codegen.scgen.msdl.em.EnumField;
import mtime.codegen.scgen.utils.Log;
import org.apache.velocity.texen.util.FileUtil;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.DocumentResult;
import org.dom4j.io.DocumentSource;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by hongfei.rong@mtime.com on 2016/8/18.
 */
public class Generator {

    public void generate(File svcFile, String codeRootPath, String resRoootPath) {
        Log.info("codeRootPath=[" + codeRootPath + "]");
        Log.info("resxRoootPath=[" + resRoootPath + "]");
        Log.info("load service description file " + svcFile.getPath());
        Document doc = getSvcXml(svcFile);
        Element rootNode = doc.getRootElement();
        String dtoStyle = rootNode.attributeValue("dtoStyle", "pojo");
        String createHtml = rootNode.attributeValue("createHtml", "false");
        String basePkg = rootNode.attributeValue("javaPackageBase", "");
        String basePkgPath = FileUtil.combinePath(codeRootPath, basePkg.replace('.', File.separatorChar));
        TransformerFactory txFactory = TransformerFactory.newInstance();
        //
        String filename = svcFile.getName();
        filename = filename.substring(0, filename.indexOf('.'));
        genEnum(txFactory, doc, basePkgPath);


    }

    private void genEnum(TransformerFactory txFactory, Document doc, String basePkgPath) {
        try {
            InputStream xlsInputStream = getClass().getClassLoader().getResourceAsStream("xsl/enum.xsl");
            Transformer tx = txFactory.newTransformer(new StreamSource(xlsInputStream));
            List enumNodes = doc.selectNodes("root/enums/enum");
            for (Object n : enumNodes) {
                Element enumNode = (Element) n;
                for (Object n2 : enumNode.selectNodes("field")) {
                    Element fieldNode = (Element) n2;
                    fieldNode.addAttribute("name", fieldNode.attributeValue("name").toUpperCase());
                    // System.out.println(fieldNode.attributeValue("name"));
                }
            }
            //
            DocumentSource src = new DocumentSource(doc);
            DocumentResult rzt = new DocumentResult();
            tx.transform(src, rzt);
            Document rztDoc = rzt.getDocument();
            String filePath = FileUtil.combinePath(basePkgPath, "constant");
            FileUtil.mkdir(filePath);
            for (Object jn : rztDoc.selectNodes("enums/enum")) {
                Element jenumNode = (Element) jn;
                String enumName = jenumNode.attributeValue("name");
                String jenumFilePath = FileUtil.combinePath(filePath, enumName + ".java");

                Writer writer = null;
                try {
                    writer = new OutputStreamWriter(new FileOutputStream(jenumFilePath), "utf-8");
                    String enumCodes = jenumNode.getText();
                    enumCodes = enumCodes.replace(",;", ";");
                    writer.write(enumCodes);
                } finally {
                    if (writer != null) {
                        writer.close();
                    }
                }

                Log.info("gen enum %s at %s", enumName, jenumFilePath);
            }

        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    private Map<String, EnumInfo> getAllEnums(Document doc) {
        Map<String, EnumInfo> aEnum = new HashMap<>();
        List dtNodes = doc.selectNodes("root/enums/enum");
        if (dtNodes != null && !dtNodes.isEmpty()) {
            for (Object o : dtNodes) {
                Element dtNode = (Element) o;
                String dtName = dtNode.attributeValue("name");
                if (dtName != null) {
                    EnumInfo typeInfo = buildEnumType(dtName,
                            dtNode,
                            dtNode.attributeValue("description"));
                    aEnum.put(dtName, typeInfo);
                }
            }
        }
        return aEnum;
    }

    private EnumInfo buildEnumType(String name, Element dtNode, String description) {
        EnumInfo info = new EnumInfo();
        info.setComment(description);
        List<EnumField> es = new ArrayList<>();
        List fnodes = dtNode.selectNodes("field");
        if (fnodes != null && !fnodes.isEmpty()) {
            for (Object o : fnodes) {
                Element fele = (Element) o;
                EnumField ef = new EnumField();
                ef.setComment(fele.attributeValue("description"));
                ef.setName(fele.attributeValue("name"));
                ef.setValue(Integer.parseInt(fele.attributeValue("value")));
                es.add(ef);
            }
        }
        info.setFields(es);
        info.setName(name);
        return info;
    }
}

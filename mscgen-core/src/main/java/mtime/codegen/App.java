package mtime.codegen;

import mtime.codegen.scgen.Generator;
import mtime.codegen.scgen.utils.FileUtil;
import mtime.codegen.scgen.utils.Log;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FilenameFilter;
import java.text.MessageFormat;

/**
 * Created by hongfei.rong@mtime.com on 2016/8/18.
 */
public class App {
    public static void main(String[] args) {
        String prjPath = System.getProperty("d");
        if (StringUtils.isBlank(prjPath)) {
            // HACK: for compatible with version 0.1.x
            if (args == null || args.length < 2) {
                prjPath = ".";
            } else {
                prjPath = args[1];
            }
        }

        genContractStuff(prjPath);

        Log.info("DONE");
    }
    private static void genContractStuff(String prjPath) {

        Log.info("project path " + prjPath);

        Generator contractGen = new Generator();

        String mainRootPath = FileUtil.combinePath(prjPath, MessageFormat.format("src{0}main", File.separator));
        String codeRootPath = FileUtil.combinePath(mainRootPath, "java");
        String resxRoootPath = FileUtil.combinePath(mainRootPath, "resources");
        String msdlPath = FileUtil.combinePath(mainRootPath, "msdl");

        try {
            File dir = new File(msdlPath);
            File[] svcXmlFiles = dir.listFiles(new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    if (name.endsWith(".xml")) {
                        return !name.endsWith("index.xml");
                    }
                    return false;
                }
            });
            if (svcXmlFiles == null || svcXmlFiles.length == 0) {
                Log.info("not found any svc xml in " + msdlPath);
                return;
            }

            for (File f : svcXmlFiles) {
                Log.info("parse " + f.getName());
                contractGen.generate(f, codeRootPath, resxRoootPath);
            }
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage(), e);
        }
    }
}

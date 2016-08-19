package mtime.codegen.scgen.utils;

/**
 * Created by hongfei.rong@mtime.com on 2016/8/18.
 */
public class Log {
    public static void info(String format, String... args) {
        System.out.println(String.format(format, args));
    }
}

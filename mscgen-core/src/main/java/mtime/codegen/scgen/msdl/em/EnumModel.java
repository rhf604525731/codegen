package mtime.codegen.scgen.msdl.em;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * Example:
 * <pre>
 *    <enums>
 *       <enum name="SaleStrategyType" description="策略类型">
 *          <field name="Primary" value="1" description="主策略"/>
 *          <field name="Secondary" value="2" description="补充策略"/>
 *       </enum>
 *    </enums>
 * </pre>
 * <p>
 * Created by hongfei.rong@mtime.com on 2016/8/18.
 */
@Getter
@Setter
public class EnumModel {
    private String name;
    private String description;
    private List<EnumField> fields;

}

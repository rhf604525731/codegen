<?xml version="1.0" encoding="UTF-8"?>
<!--
    此 XSL 实现将多个 MSDL 转为 HTML 文档；
    注意，不要使用任何工具进行格式化，应该保持空格、缩进、换行等原样布局；
    大部分浏览器都支持实用 XSL 对 XML 进行转换，即可直接浏览 index.xml；
    但，本地文件，仅 FireFox/IE 支持，其他浏览器有安全限制。
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" omit-xml-declaration="yes" indent="yes" standalone="yes"/>
	<xsl:template match="root">
		<html>
			<head>
				<title>
					<xsl:value-of select="title"/>
				</title>
				<style type="text/css">
h1, h2, h3, h4, h5, h6, p, pre { padding: 4px 0px; margin: 0px; }
ul, li {padding-left:4px;margin:0px}
table { border-collapse: collapse;}
td, th{ border: solid #666 1px;}
th {background: #EEE }
				</style>
			</head>
			<body>
				<div style="padding-left:40%;">
					<h1>
						<xsl:value-of select="title"/>
					</h1>
				</div>
				<div style="padding-left:16px;float:left;width:200px;position:fixed;overflow-y:auto;">
					<ul>
						<li>接口定义
							<xsl:for-each select="entry">
								<xsl:for-each select="document(concat(.,'.xml'))/root/services">
									<ul>
										<xsl:for-each select="service">
											<li>
												<a>
													<xsl:attribute name="href">#svc_<xsl:value-of select="@name"/>
													</xsl:attribute>
													<xsl:value-of select="@name"/>Service
												</a>
												<ul>
													<xsl:for-each select="method">
														<li>
															<a>
																<xsl:attribute name="href">#method_<xsl:value-of select="@name"/>
																</xsl:attribute>
																<xsl:value-of select="@name"/>
															</a>
														</li>
													</xsl:for-each>
												</ul>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:for-each>
							</xsl:for-each>
						</li>
						<li>类型定义
							<xsl:for-each select="entry">
								<xsl:for-each select="document(concat(.,'.xml'))/root/dataTypes">
									<ul>
										<xsl:for-each select="dataType">
											<li>
												<a>
													<xsl:attribute name="href">#type_<xsl:value-of select="@name"/>
													</xsl:attribute>
													<xsl:value-of select="@name"/>
												</a>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:for-each>
							</xsl:for-each>
						</li>
						<li>枚举定义
							<xsl:for-each select="entry">
								<xsl:for-each select="document(concat(.,'.xml'))/root/enums">
									<ul>
										<xsl:for-each select="enum">
											<li>
												<a>
													<xsl:attribute name="href">#enum_<xsl:value-of select="@name"/>
													</xsl:attribute>
													<xsl:value-of select="@name"/>
												</a>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:for-each>
							</xsl:for-each>
						</li>
					</ul>
				</div>
				<div style="padding-left:220px;float:left;">
					<h2>接口定义</h2>
					<xsl:for-each select="entry">
						<xsl:apply-templates select="document(concat(.,'.xml'))/root/services"/>
					</xsl:for-each>
					<h2>类型定义</h2>
					<xsl:for-each select="entry">
						<xsl:apply-templates select="document(concat(.,'.xml'))/root/dataTypes"/>
					</xsl:for-each>
					<h2>枚举定义</h2>
					<xsl:for-each select="entry">
						<xsl:apply-templates select="document(concat(.,'.xml'))/root/enums"/>
					</xsl:for-each>
					<div style="height:40px"></div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="service">
		<h2>
			<a>
				<xsl:attribute name="name">svc_<xsl:value-of select="@name"/>
				</xsl:attribute>
				<xsl:value-of select="@name"/>Service
			</a>
		</h2>
		<p>
			<xsl:value-of select="@description"/>
		</p>
		<xsl:for-each select="method">
			<h3>
				<a>
					<xsl:attribute name="name">method_<xsl:value-of select="@name"/>
					</xsl:attribute>
					<xsl:value-of select="@name"/>
				</a>
			</h3>
			<p>
				<xsl:value-of select="@description"/>
			</p>
			<h4>请求参数</h4>
			<pre>
<xsl:choose>
    <xsl:when test="request">
// <xsl:value-of select="request/@description"/>
message	<xsl:value-of select="@name"/>Request {
<xsl:for-each select="request/field">
<xsl:text>	</xsl:text>// <xsl:value-of select="@description"/> <xsl:choose><xsl:when test="@enum != ''"> 参见枚举：<a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@enum"/></a></xsl:when></xsl:choose><xsl:text>
  	</xsl:text><xsl:value-of select="@modifier"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@enum != ''"><a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:when test="@type != 'int32' and @type != 'int64' and @type != 'string' and @type != 'bool'"><a><xsl:attribute name="href">#type_<xsl:value-of select="@type"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise></xsl:choose><xsl:text> </xsl:text><xsl:value-of select="@name"/> = <xsl:value-of select="@order"/>;
</xsl:for-each>
}
    </xsl:when>
    <xsl:otherwise>
        无
    </xsl:otherwise>
</xsl:choose>
			</pre>
			<h4>响应结果</h4>
			<pre>
<xsl:choose>
    <xsl:when test="response">
// <xsl:value-of select="response/@description"/>
message <xsl:value-of select="@name"/>Response {
<xsl:for-each select="response/field">
<xsl:text>	</xsl:text>// <xsl:value-of select="@description"/>  <xsl:choose><xsl:when test="@enum != ''"> 参见枚举：<a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@enum"/></a></xsl:when></xsl:choose><xsl:text>
  	</xsl:text><xsl:value-of select="@modifier"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@enum != ''"><a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:when test="@type != 'int32' and @type != 'int64' and @type != 'string' and @type != 'bool'"><a><xsl:attribute name="href">#type_<xsl:value-of select="@type"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise></xsl:choose><xsl:text> </xsl:text><xsl:value-of select="@name"/> = <xsl:value-of select="@order"/>;
</xsl:for-each>
}
    </xsl:when>
    <xsl:otherwise>
        无
    </xsl:otherwise>
</xsl:choose>

			</pre>
			<h4>请求示例</h4>
			<h4>响应示例</h4>
			<h4>错误代码</h4>
			<table>
				<xsl:for-each select="errors/error">
					<tr>
						<td>
							<xsl:value-of select="@code"/>
						</td>
						<td>
							<xsl:value-of select="@message"/>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dataType">
		<h3>
			<a>
				<xsl:attribute name="name">type_<xsl:value-of select="@name"/>
				</xsl:attribute>
				<xsl:value-of select="@name"/>
			</a>
		</h3>
		<pre>
// <xsl:value-of select="@description"/>
message	<xsl:value-of select="@name"/> {
<xsl:for-each select="field">
	<xsl:text>	</xsl:text>// <xsl:value-of select="@description"/> <xsl:choose><xsl:when test="@enum != ''"> 参见枚举：<a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@enum"/></a></xsl:when></xsl:choose><xsl:text>
	</xsl:text><xsl:value-of select="@modifier"/><xsl:text> </xsl:text><xsl:choose><xsl:when test="@enum != ''"><a><xsl:attribute name="href">#enum_<xsl:value-of select="@enum"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:when test="@type != 'int32' and @type != 'int64' and @type != 'string' and @type != 'bool'"><a><xsl:attribute name="href">#type_<xsl:value-of select="@type"/></xsl:attribute><xsl:value-of select="@type"/></a></xsl:when><xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise></xsl:choose><xsl:text> </xsl:text><xsl:value-of select="@name"/> = <xsl:value-of select="@order"/>;
</xsl:for-each>
}
		</pre>
	</xsl:template>
	<xsl:template match="enum">
		<h3>
			<a>
				<xsl:attribute name="name">enum_<xsl:value-of select="@name"/>
				</xsl:attribute>
				<xsl:value-of select="@name"/>
			</a>
		</h3>
		<p>
			<xsl:value-of select="@description"/>
		</p>
		<table>
			<tr>
				<th style="width:160px">名称</th>
				<th style="width:40px">数值</th>
				<th style="width:300px">说明</th>
			</tr>
			<xsl:for-each select="field">
				<tr>
					<td>
						<xsl:value-of select="@name"/>
					</td>
					<td>
						<xsl:value-of select="@value"/>
					</td>
					<td>
						<xsl:value-of select="@description"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
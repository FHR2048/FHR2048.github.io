<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <!-- 提取纯文本内容 -->
  <xsl:template name="extract-text">
    <xsl:param name="content"/>
    <xsl:choose>
      <xsl:when test="contains($content, '&lt;')">
        <xsl:value-of select="substring-before($content, '&lt;')"/>
        <xsl:variable name="after" select="substring-after($content, '&gt;')"/>
        <xsl:call-template name="extract-text">
          <xsl:with-param name="content" select="$after"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/">
    <html lang="zh-CN">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>
          <xsl:value-of select="/atom:feed/atom:title"/> - 茯茯小站订阅源
        </title>
        <style>
          :root {
            --bg-color: #f8fafc;
            --text-color: #1e293b;
            --card-bg: rgba(255, 255, 255, 0.8);
            --border-color: #e2e8f0;
            --accent-color: #4f46e5;
            --muted-color: #64748b;
            --header-text: #66CCFF;
            --footer-text: #fff;
            --footer-a: #e28959ff;
            --footer-a-hover: #f79662ff;
            --header-muted: #6b7280;
            --subscribe-bg: #f3f4f6;
          }
          
          @media (prefers-color-scheme: dark) {
            :root {
              --bg-color: #0f172a;
              --text-color: #f8fafc;
              --card-bg: rgba(30, 41, 59, 0.8);
              --border-color: #334155;
              --accent-color: #818cf8;
              --muted-color: #94a3b8;
              --header-text: #66CCFF;
              --header-muted: #9ca3af;
              --subscribe-bg: #1f2937;
            }
          }
          
          * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }
          
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--bg-color);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            background-image: url('https://fhr2048.github.io/img/RSSBG.jpg');
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
          }
          
          body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            backdrop-filter: blur(5px);
            z-index: -1;
          }
          
          a {
            color: var(--accent-color);
            text-decoration: none;
            transition: color 0.2s;
          }
          
          a:hover {
            color: #2563eb;
            text-decoration: underline;
          }
          
          .container {
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1rem;
          }
          
          .header {
            padding: 2rem 0;
            color: var(--header-text);
          }

          .header-top {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px dashed var(--header-text);
          }

          .header-avatar img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
          }

          .header-title {
            font-size: 1.8rem;
            font-weight: 700;
          }

          .header-description {
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
            color: var(--header-text);
            line-height: 1.7;
          }

          .header-subscribe {
            margin-top: 2rem;
            padding: 1.2rem;
            background: var(--subscribe-bg);
            border-radius: 0.75rem;
            border-left: 4px solid var(--accent-color);
            font-size: 1rem;
            color: var(--header-muted);
            line-height: 1.6;
          }

          .header-subscribe a {
            color: var(--accent-color);
            font-weight: 600;
          }
          
          .article-list {
            display: grid;
            gap: 1.8rem;
            margin-top: 2rem;
          }
          
          .article-card {
            background-color: var(--card-bg);
            backdrop-filter: blur(8px);
            border-radius: 1rem;
            padding: 1.8rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
          }
          
          .article-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
          }
          
          .article-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: var(--header-text);
          }
          
          .article-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            color: var(--muted-color);
            font-size: 0.9rem;
            margin-bottom: 1.2rem;
          }
          
          .article-summary {
            margin-bottom: 1.2rem;
            color: var(--text-color);
            line-height: 1.7;
          }
          
          .article-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.6rem;
            margin-top: 1.2rem;
          }
          
          .tag {
            background-color: var(--border-color);
            color: var(--text-color);
            padding: 0.3rem 0.8rem;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            transition: all 0.2s;
          }
          
          .tag:hover {
            background-color: var(--accent-color);
            color: white;
          }
          
          .footer {
            margin-top: 4rem;
            padding: 2rem 1rem;
            text-align: center;
            color: var(--footer-text);
            font-size: 1rem;
          }

          .footer-line {
            margin: 0.5rem 0;
          }

          .footer-line > a {
            color: var(--footer-a);
          }

          .footer-line > a:hover {
            color: var(--footer-a-hover);
          }
        </style>
      </head>
      <body>
        <div class="container">
          <header class="header">
            <div class="header-top">
              <div class="header-avatar">
              <img src="https://fhr2048.github.io/img/avatar.png" alt="MortalCat"/>
              </div>
              <h1 class="header-title">
                <xsl:value-of select="/atom:feed/atom:title"/>
              </h1>
            </div>

            <div class="header-description">
              <p>茯茯小站 订阅源</p>
              <p style="margin-top: 0.8rem">RSS</p>
            </div>

            <div class="header-subscribe">
              <p>
                使用 RSS 阅读器订阅：
                <a href="https://feedly.com/i/subscription/feed/{/atom:feed/atom:link[@rel='self']/@href}" target="_blank" rel="noopener">Feedly</a>,
                <a href="https://www.inoreader.com/feed/{/atom:feed/atom:link[@rel='self']/@href}" target="_blank" rel="noopener">Inoreader</a>,
                <a href="https://www.newsblur.com/?url={/atom:feed/atom:link[@rel='self']/@href}" target="_blank" rel="noopener">Newsblur</a>,
                <a href="follow://add?url={/atom:feed/atom:link[@rel='self']/@href}" rel="noopener">Follow</a>
                或直接复制源链接：
                <code style="display: block; margin-top: 0.8rem; padding: 0.5rem; background: rgba(0,0,0,0.05); border-radius: 4px; overflow-x: auto; font-size: 0.9rem;">
                  <xsl:value-of select="/atom:feed/atom:link[@rel='self']/@href"/>
                </code>
              </p>
            </div>
          </header>

          <div class="article-list">
            <xsl:for-each select="/atom:feed/atom:entry">
              <article class="article-card">
                <h2 class="article-title">
                  <a href="{atom:link/@href}" target="_blank">
                    <xsl:value-of select="atom:title"/>
                  </a>
                </h2>
                <div class="article-meta">
                  <time>
                    <xsl:value-of select="substring(atom:published, 1, 10)"/>
                  </time>
                  <span>•</span>
                  <span>
                    <xsl:value-of select="atom:category/@term"/>
                  </span>
                </div>
                <div class="article-summary">
                  <xsl:choose>
                    <xsl:when test="atom:summary">
                      <!-- 关键修改：提取纯文本内容 -->
                      <xsl:variable name="rawSummary" select="atom:summary"/>
                      <xsl:variable name="cleanSummary">
                        <xsl:call-template name="extract-text">
                          <xsl:with-param name="content" select="$rawSummary"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:value-of select="substring($cleanSummary, 1, 300)"/>
                      <xsl:if test="string-length($cleanSummary) > 300">...</xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="rawContent" select="atom:content"/>
                      <xsl:variable name="cleanContent">
                        <xsl:call-template name="extract-text">
                          <xsl:with-param name="content" select="$rawContent"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:value-of select="substring($cleanContent, 1, 300)"/>
                      <xsl:if test="string-length($cleanContent) > 300">...</xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <xsl:if test="atom:category">
                  <div class="article-tags">
                    <xsl:for-each select="atom:category">
                      <span class="tag">
                        <xsl:value-of select="@term"/>
                      </span>
                    </xsl:for-each>
                  </div>
                </xsl:if>
              </article>
            </xsl:for-each>
          </div>

          <footer class="footer">
            <div class="footer-line">
              © <xsl:value-of select="substring(/atom:feed/atom:updated, 1, 4)"/> • 
              <xsl:value-of select="/atom:feed/atom:author/atom:name"/>
            </div>
            <div class="footer-line">
              由 <xsl:value-of select="/atom:feed/atom:generator"/> 生成 • 
              <a href="https://fhr2048.github.io/">茯茯小站</a>
            </div>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
#!/usr/bin/env node
/**
 * Wechatsync 浏览器自动化发布脚本
 * 使用 Playwright 控制浏览器，自动登录各平台并发布文章
 * 
 * 使用方法:
 *   npm install playwright
 *   node auto-publish-browser.js
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

// 配置
const CONFIG = {
  // 文章配置
  articles: [
    {
      id: 'article11',
      title: '248K Star！黄仁勋说它是\'下一个Linux\'，60天刷新GitHub纪录！',
      file: 'publish/article11/wechat/openclaw-wechat.md',
      cover: 'article11/images/cover.png',
      tags: ['OpenClaw', 'AI助手', '开源', 'GitHub', '黄仁勋', 'Rust'],
      platforms: ['wechat', 'zhihu', 'juejin', 'weibo', 'toutiao', 'csdn']
    },
    {
      id: 'article15',
      title: '20K Star！撕开AI的遮羞布，所有大模型的\'底层剧本\'全泄露！',
      file: 'publish/article15/wechat/prompts-leak-wechat.md',
      cover: 'article15/images/cover.png',
      tags: ['AI安全', '提示词泄露', 'ChatGPT', 'Claude', '大模型', 'GPT5'],
      platforms: ['wechat', 'zhihu', 'juejin', 'weibo', 'toutiao', 'csdn']
    }
  ],
  
  // 平台登录地址
  loginUrls: {
    wechat: 'https://mp.weixin.qq.com/',
    zhihu: 'https://www.zhihu.com/signin',
    juejin: 'https://juejin.cn/login',
    weibo: 'https://weibo.com/login.php',
    toutiao: 'https://mp.toutiao.com/',
    csdn: 'https://passport.csdn.net/login'
  },
  
  // 平台发布地址
  publishUrls: {
    wechat: 'https://mp.weixin.qq.com/cgi-bin/appmsg?t=media/appmsg_edit_v2&action=edit&isNew=1&type=10&createType=10',
    zhihu: 'https://zhuanlan.zhihu.com/write',
    juejin: 'https://juejin.cn/editor/drafts/new',
    weibo: 'https://weibo.com/compose/',
    toutiao: 'https://mp.toutiao.com/profile_v4/graphic/publish',
    csdn: 'https://mp.csdn.net/mp_blog/creation/editor'
  }
};

/**
 * 读取文章文件内容
 */
function readArticle(filePath) {
  const fullPath = path.join(__dirname, '..', filePath);
  return fs.readFileSync(fullPath, 'utf-8');
}

/**
 * 读取封面图片为 Base64
 */
function readCoverImage(filePath) {
  const fullPath = path.join(__dirname, '..', filePath);
  const buffer = fs.readFileSync(fullPath);
  return buffer.toString('base64');
}

/**
 * 发布到微信公众号
 */
async function publishToWechat(page, article) {
  console.log('  🔄 正在发布到微信公众号...');
  
  try {
    await page.goto(CONFIG.publishUrls.wechat, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 填写标题
    const titleInput = await page.$('#title');
    if (titleInput) {
      await titleInput.fill(article.title);
    }
    
    // 填写正文（使用富文本编辑器）
    const content = readArticle(article.file);
    // 切换到富文本编辑器 iframe
    const editorFrame = await page.frameLocator('#edui1_iframeholder, .edui-editor-iframeholder, iframe[src*="ueditor"]').first();
    if (editorFrame) {
      await editorFrame.locator('body').fill(content);
    }
    
    // 上传封面图
    const coverInput = await page.$('input[type="file"][accept*="image"]');
    if (coverInput) {
      const coverPath = path.join(__dirname, '..', article.cover);
      await coverInput.setInputFiles(coverPath);
      await page.waitForTimeout(2000);
    }
    
    // 保存为草稿
    const saveBtn = await page.$('button:has-text("保存"), #js_save, .btn_save');
    if (saveBtn) {
      await saveBtn.click();
      await page.waitForTimeout(2000);
    }
    
    console.log('  ✅ 微信公众号草稿保存成功');
    return true;
  } catch (error) {
    console.log(`  ❌ 微信公众号发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 发布到知乎
 */
async function publishToZhihu(page, article) {
  console.log('  🔄 正在发布到知乎...');
  
  try {
    await page.goto(CONFIG.publishUrls.zhihu, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 填写标题
    const titleInput = await page.$('input[placeholder*="标题"], .TitleInput, [data-testid="title-input"]');
    if (titleInput) {
      await titleInput.fill(article.title);
    }
    
    // 填写正文
    const content = readArticle(article.file);
    const editor = await page.$('.RichText, .Editable, [contenteditable="true"]');
    if (editor) {
      await editor.fill(content);
    }
    
    // 添加话题
    for (const tag of article.tags.slice(0, 3)) {
      const topicInput = await page.$('input[placeholder*="话题"], .TopicInput');
      if (topicInput) {
        await topicInput.fill(tag);
        await page.waitForTimeout(1000);
        await page.keyboard.press('Enter');
      }
    }
    
    console.log('  ✅ 知乎草稿保存成功');
    return true;
  } catch (error) {
    console.log(`  ❌ 知乎发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 发布到掘金
 */
async function publishToJuejin(page, article) {
  console.log('  🔄 正在发布到掘金...');
  
  try {
    await page.goto(CONFIG.publishUrls.juejin, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 填写标题
    const titleInput = await page.$('input[placeholder*="标题"], .title-input');
    if (titleInput) {
      await titleInput.fill(article.title);
    }
    
    // 填写正文
    const content = readArticle(article.file);
    const editor = await page.$('.editor, [contenteditable="true"], textarea');
    if (editor) {
      await editor.fill(content);
    }
    
    // 添加标签
    for (const tag of article.tags.slice(0, 5)) {
      const tagInput = await page.$('input[placeholder*="标签"], .tag-input');
      if (tagInput) {
        await tagInput.fill(tag);
        await page.waitForTimeout(1000);
        await page.keyboard.press('Enter');
      }
    }
    
    console.log('  ✅ 掘金草稿保存成功');
    return true;
  } catch (error) {
    console.log(`  ❌ 掘金发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 发布到微博
 */
async function publishToWeibo(page, article) {
  console.log('  🔄 正在发布到微博...');
  
  try {
    await page.goto(CONFIG.publishUrls.weibo, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 微博是短内容，需要精简
    const content = readArticle(article.file);
    const shortContent = content.substring(0, 2000) + '...\n\n阅读原文：' + article.title;
    
    const editor = await page.$('textarea[title*="微博"], .W_input, [node-type="textEl"]');
    if (editor) {
      await editor.fill(shortContent);
    }
    
    // 上传图片
    const imgInput = await page.$('input[type="file"][accept*="image"]');
    if (imgInput) {
      const coverPath = path.join(__dirname, '..', article.cover);
      await imgInput.setInputFiles(coverPath);
      await page.waitForTimeout(2000);
    }
    
    console.log('  ✅ 微博草稿准备成功');
    return true;
  } catch (error) {
    console.log(`  ❌ 微博发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 发布到头条
 */
async function publishToToutiao(page, article) {
  console.log('  🔄 正在发布到头条...');
  
  try {
    await page.goto(CONFIG.publishUrls.toutiao, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 填写标题
    const titleInput = await page.$('input[placeholder*="标题"], .title-input');
    if (titleInput) {
      await titleInput.fill(article.title);
    }
    
    // 填写正文
    const content = readArticle(article.file);
    const editor = await page.$('.editor, [contenteditable="true"], textarea');
    if (editor) {
      await editor.fill(content);
    }
    
    console.log('  ✅ 头条草稿保存成功');
    return true;
  } catch (error) {
    console.log(`  ❌ 头条发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 发布到CSDN
 */
async function publishToCSDN(page, article) {
  console.log('  🔄 正在发布到CSDN...');
  
  try {
    await page.goto(CONFIG.publishUrls.csdn, { waitUntil: 'networkidle' });
    await page.waitForTimeout(3000);
    
    // 填写标题
    const titleInput = await page.$('input[placeholder*="标题"], #txtTitle');
    if (titleInput) {
      await titleInput.fill(article.title);
    }
    
    // 填写正文
    const content = readArticle(article.file);
    const editor = await page.$('.editor, [contenteditable="true"], textarea');
    if (editor) {
      await editor.fill(content);
    }
    
    // 添加标签
    for (const tag of article.tags.slice(0, 5)) {
      const tagInput = await page.$('input[placeholder*="标签"], .tag-input');
      if (tagInput) {
        await tagInput.fill(tag);
        await page.waitForTimeout(1000);
        await page.keyboard.press('Enter');
      }
    }
    
    console.log('  ✅ CSDN草稿保存成功');
    return true;
  } catch (error) {
    console.log(`  ❌ CSDN发布失败: ${error.message}`);
    return false;
  }
}

/**
 * 主函数
 */
async function main() {
  console.log('==========================================');
  console.log('🚀 多平台文章自动发布工具');
  console.log('==========================================\n');
  
  // 检查 Playwright 是否安装
  try {
    require('playwright');
  } catch {
    console.log('❌ 请先安装 Playwright:');
    console.log('   npm install playwright');
    console.log('\n然后安装浏览器:');
    console.log('   npx playwright install chromium');
    process.exit(1);
  }
  
  // 启动浏览器
  console.log('🌐 启动浏览器...');
  const browser = await chromium.launch({ 
    headless: false,  // 显示浏览器窗口，方便手动登录
    slowMo: 100 
  });
  
  const context = await browser.newContext({
    viewport: { width: 1280, height: 800 }
  });
  
  // 处理每篇文章
  for (const article of CONFIG.articles) {
    console.log(`\n📢 正在处理: ${article.title}`);
    console.log('------------------------------------------');
    
    const page = await context.newPage();
    
    // 发布到各平台
    for (const platform of article.platforms) {
      try {
        switch (platform) {
          case 'wechat':
            await publishToWechat(page, article);
            break;
          case 'zhihu':
            await publishToZhihu(page, article);
            break;
          case 'juejin':
            await publishToJuejin(page, article);
            break;
          case 'weibo':
            await publishToWeibo(page, article);
            break;
          case 'toutiao':
            await publishToToutiao(page, article);
            break;
          case 'csdn':
            await publishToCSDN(page, article);
            break;
        }
      } catch (error) {
        console.log(`  ❌ ${platform} 平台异常: ${error.message}`);
      }
      
      await page.waitForTimeout(2000);
    }
    
    await page.close();
  }
  
  console.log('\n==========================================');
  console.log('✅ 所有文章已处理完成');
  console.log('==========================================');
  console.log('\n📋 请检查各平台草稿箱，确认内容无误后手动发布');
  console.log('⚠️  注意: 首次使用需要手动登录各平台');
  
  // 保持浏览器打开
  console.log('\n按 Ctrl+C 关闭浏览器...');
}

// 运行
main().catch(console.error);

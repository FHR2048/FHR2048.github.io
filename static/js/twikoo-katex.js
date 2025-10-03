// Twikoo评论系统Katex和mhchem支持
document.addEventListener('DOMContentLoaded', function() {
  // 配置mhchem扩展
  if (typeof katex !== 'undefined') {
    // 确保mhchem扩展已加载并注册
    try {
      if (typeof mhchem !== 'undefined') {
        console.log('mhchem扩展已加载');
      }
    } catch (e) {
      console.warn('mhchem扩展加载可能有问题:', e);
    }
  }
  
  // 渲染数学公式的函数
  function renderAllMath() {
    if (typeof renderMathInElement !== 'function') {
      console.log('renderMathInElement函数未加载');
      return;
    }
    
    // 配置Katex选项，包含mhchem支持
    const katexOptions = {
      delimiters: [
        {left: '$$', right: '$$', display: true},
        {left: '$', right: '$', display: false},
        {left: '\\(', right: '\\)', display: false},
        {left: '\\[', right: '\\]', display: true}
      ],
      throwOnError: false,
      strict: false,
      trust: true,
      // 添加宏定义以确保\ce命令被识别
      macros: {
        "\\ce": "\\ce{#1}",
        "\\pu": "\\pu{#1}"
      }
    };
    
    // 渲染整个页面的公式
    renderMathInElement(document.body, katexOptions);
    
    // 特别渲染评论区域
    const commentArea = document.getElementById('tcomment');
    if (commentArea) {
      renderMathInElement(commentArea, katexOptions);
    }
  }
  
  // 初始渲染
  setTimeout(renderAllMath, 100);
  
  // 监听评论区域变化
  const observer = new MutationObserver(function(mutations) {
    let shouldRender = false;
    mutations.forEach(function(mutation) {
      if (mutation.addedNodes.length) {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === 1) {
            if (node.classList && (
              node.classList.contains('tk-comment') ||
              node.querySelector('.tk-comment')
            )) {
              shouldRender = true;
            }
          }
        });
      }
    });
    if (shouldRender) {
      setTimeout(renderAllMath, 200);
    }
  });
  
  const commentContainer = document.getElementById('tcomment');
  if (commentContainer) {
    observer.observe(commentContainer, {
      childList: true,
      subtree: true
    });
  }
  
  // 监听页面变化
  window.addEventListener('popstate', function() {
    setTimeout(renderAllMath, 300);
  });
});
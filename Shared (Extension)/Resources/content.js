console.log("Content script initialized!");

// Redirect URL
const redirectUrl = "https://www.inspiringquotes.com/";

// Function to check if the current URL matches any blocked sites
function isUrlBlocked(blockedUrls, currentUrl) {
  console.log("=== URL Check ===");
  console.log("Checking URL:", currentUrl);
  console.log("Against blocked URLs:", blockedUrls);

  if (!blockedUrls || blockedUrls.length === 0) {
    console.warn("No blocked URLs provided!");
    return false;
  }

  return blockedUrls.some((blockedUrl) => {
    const normalizedBlockedUrl = blockedUrl.toLowerCase();
    const normalizedCurrentUrl = currentUrl.toLowerCase();
    const isBlocked = normalizedCurrentUrl.includes(normalizedBlockedUrl);
    console.log(
      `Checking ${normalizedBlockedUrl} against ${normalizedCurrentUrl}: ${isBlocked}`
    );
    return isBlocked;
  });
}

// Function to request blocked URLs from background script
function requestBlockedUrls() {
  console.log("=== Requesting Blocked URLs ===");
  try {
    browser.runtime.sendMessage({ name: "getBlockedUrls" }).catch((error) => {
      console.error("Error sending message to background script:", error);
    });
  } catch (error) {
    console.error("Error in requestBlockedUrls:", error);
  }
}

// Function to block the website
function blockWebsite() {
  console.log("=== Blocking Website ===");
  try {
    document.body.innerHTML = `
           <!DOCTYPE html>
           <html lang="en">
           <head>
               <meta charset="UTF-8">
               <meta name="viewport" content="width=device-width, initial-scale=1.0">
               <title>CutOff Blocker</title>
               <style>
                   body {
                       margin: 0;
                       padding: 0;
                       box-sizing: border-box;
                       font-family: 'Arial', sans-serif;
                       background: linear-gradient(to bottom, #4A90E2, #9013FE);
                       color: #fff;
                       display: flex;
                       justify-content: center;
                       align-items: center;
                       height: 100vh;
                       text-align: center;
                   }
                   .blocker-container {
                       background: rgba(255, 255, 255, 0.1);
                       padding: 30px;
                       border-radius: 15px;
                       box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                   }
                   h1 {
                       font-size: 2rem;
                       margin-bottom: 15px;
                   }
                   p {
                       font-size: 1rem;
                       opacity: 0.9;
                   }
                   .redirect-animation {
                       margin-top: 20px;
                       font-size: 0.9rem;
                       animation: fadeInOut 2s infinite;
                   }
                   @keyframes fadeInOut {
                       0%, 100% {
                           opacity: 0.3;
                       }
                       50% {
                           opacity: 1;
                       }
                   }
               </style>
           </head>
           <body>
               <div class="blocker-container">
                   <h1>This site is blocked by CutOff Blocker!</h1>
                   <p>Redirecting to your productivity reminder...</p>
                   <div class="redirect-animation">Stay focused! 🚀</div>
               </div>
           </body>
           </html>

        `;

    setTimeout(() => {
      window.location.href = redirectUrl;
    }, 2000);
  } catch (error) {
    console.error("Error in blockWebsite:", error);
  }
}

// Listen for blocked URLs from background script
browser.runtime.onMessage.addListener((message) => {
  console.log("=== Message Received in Content Script ===");
  console.log("Message:", message);

  if (message.name === "blockedUrls") {
    console.log("Blocked URLs message received");
    console.log("URLs in message:", message.urls);

    const currentUrl = window.location.href;
    console.log("Current URL:", currentUrl);

    if (isUrlBlocked(message.urls, currentUrl)) {
      console.log("Site is blocked, initiating block...");
      blockWebsite();
    } else {
      console.log("Site is not blocked");
    }
  }
});

// Initialize
console.log("=== Content Script Setup ===");
if (document.readyState === "loading") {
  console.log("Document still loading, adding DOMContentLoaded listener");
  document.addEventListener("DOMContentLoaded", requestBlockedUrls);
} else {
  console.log("Document already loaded, requesting URLs immediately");
  requestBlockedUrls();
}

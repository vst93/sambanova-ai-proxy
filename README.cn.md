# sambanova-ai-proxy

> ⚠️ 本仓库中的所有内容仅用于实验目的

> ⚠️ 使用此程序，即表示您同意 Sambanova 的[使用条款](https://sambanova.ai/model-demo-tou)和[隐私政策](https://sambanova.ai/privacy-policy)，这些政策允许他们根据这些政策使用您发送到他们服务器的任何内容。因此，您不应使用它来处理任何敏感信息。

sambanova-ai-proxy 是一个非常简单的 HTTP 代理服务器，它将您的 OpenAI 兼容的聊天完成请求重定向到 [sambanova](https://sambanova.ai/)。Sambanova 提供了一个无需登录即可使用的免费LLM网页，用于体验 llama3.1 405B 模型，但为什么不直接给我们一个免费的 API，让我们可以在我们最喜欢的应用和聊天界面中尝试这些模型呢？朋友，你来对地方了。

这个仓库填补了 Sambanova 网页和使用 LLM API 的程序之间的空白，让我们能更好地理解 Sambanova AI 提供的服务。

要运行这个程序，请克隆仓库并使用 `node` 运行 `server.js`：

~~~sh
node server.js
~~~

这个服务器默认监听 `localhost:11435/v1/api/completion`。`/v1/api/completion` 是唯一支持的路由。

要在使用 OpenAI API 或 Ollama API 的应用程序中使用此服务器，将基础 URL 替换为 `http://localhost:11435/v1/`。它将是一个即插即用的替代品。

这个程序还允许您覆盖服务器接收到的模型名称，并将其替换为服务器程序中指定的名称。这个功能很有帮助，因为一些使用 OpenAI API 的程序不允许您更改模型名称，这阻止了我们测试这些开源模型。

要实现这一点，您可以修改 `server.js` 文件顶部的 `MODEL_OVERRIDE` 参数。如果 `MODEL_OVERRIDE` 包含任何值，在代理请求时，服务器将用 `MODEL_OVERRIDE` 的值替换模型参数中的原始值。

## 在 Cloudflare Worker 上运行

将 `cf-worker.js` 的内容复制并粘贴到您的 cloudflare worker 中并部署。Sambanova AI 代理服务器将作为无服务器端点在您的 cloudflare worker 上运行！

## Docker

这个项目的 Docker 镜像托管在 GitHub Container Registry 上，并通过 GitHub 动作自动构建。

docker run
~~~sh
docker run -d\
  --name sambanova-ai-proxy \
  -p 11435:11435 \
  --read-only \
  ghcr.io/lingo34/sambanova-ai-proxy:main
~~~

如果您想启用模型覆盖并指定一个模型，可以将其作为环境变量传递。
~~~sh
docker run -d\
  --name sambanova-ai-proxy \
  -p 11435:11435 \
  --read-only \
  -e MODEL_OVERRIDE="llama3-405b" \
  ghcr.io/lingo34/sambanova-ai-proxy:main
~~~

或者您可以使用 docker compose：在项目目录中执行：
~~~sh
docker compose up -d
~~~

这是 docker compose 文件
~~~yaml
version: '3.8'

services:
  node-server:
    image: ghcr.io/lingo34/sambanova-ai-proxy:main
    container_name: sambanova-ai-proxy
    ports:
      - "11435:11435"
    environment:
      - MODEL_OVERRIDE=""
    read_only: true
    restart: unless-stopped
~~~

或者，如果您想自己构建镜像

~~~sh
docker build -t sambanova-ai-proxy .
~~~

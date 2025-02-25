FROM node:20-alpine AS build
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
# 安装 corepack 并启用 pnpm
RUN npm install -g corepack@latest && corepack enable
COPY . /app
WORKDIR /app
# 使用缓存加速 pnpm 安装
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run generate


FROM node:20-alpine
WORKDIR /app/public
COPY --from=build /app/.output /app
RUN npm install -g serve@14.2.3 && npm cache clean --force
EXPOSE 3000
CMD ["npx", "serve"]


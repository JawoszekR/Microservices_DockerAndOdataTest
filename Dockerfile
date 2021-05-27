#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
ENV ASPNETCORE_URLS=http://+:80 
ENV ASPNETCORE_URLS=http://+:443 
#ENV ASPNETCORE_HTTPS_PORT=443


FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["Microservice/Microservice.csproj", ""]
RUN dotnet restore "./Microservice.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Microservice/Microservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Microservice/Microservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Microservice.dll", "--server.urls", "http://*"]
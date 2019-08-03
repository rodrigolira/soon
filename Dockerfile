FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY src/Soon.Web/*.csproj ./src/Soon.Web/
RUN dotnet restore

# copy everything else and build app
COPY src/. ./src/
WORKDIR /app/src/Soon.Web
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-alpine AS runtime
WORKDIR /app
COPY --from=build /app/src/Soon.Web/out ./

ENV ASPNETCORE_URLS http://0.0.0.0:5000

EXPOSE 5000

ENTRYPOINT ["dotnet", "Soon.Web.dll"]
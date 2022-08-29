#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["AwsP1/AwsP1.csproj", "AwsP1/"]
COPY ["TestProject1/TestProject1.csproj", "TestProject1/"]
RUN dotnet restore "AwsP1/AwsP1.csproj"
COPY . .
WORKDIR "/src/AwsP1"
RUN dotnet build "AwsP1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AwsP1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AwsP1.dll"]

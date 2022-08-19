#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["dockerSampleCoreApp.csproj", "."]
RUN dotnet restore "./dockerSampleCoreApp.csproj"
#RUN dotnet restore  C:\Users\MShafi\source\repos\dotnetframeworkwindowscont\dockerSampleCoreApp.csproj  #dockerSampleCoreApp.csproj*
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerSampleCoreApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerSampleCoreApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerSampleCoreApp.dll"]
-- lua는 "--" 가 주석이다.

workspace "Hazel"		-- 솔루션 파일 이름
	architecture "x64"	-- 솔루션의 architecture, 64bit 로 설정

	configurations		-- 구성 (debug 모드, release 모드 등 어떤 구성이 있는지?)
	{
		"Debug",
		"Release",
		"Dist"
	}

-- 결과물 폴더 경로를 outputdit 변수에 저장
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"			-- 프로젝트 이름
	location "Hazel"
	kind "SharedLib"	-- 빌드 후 생성되는 파일의 종류 (ex. 실행파일(exe)인지 라이브러리(lib or dll)인지
	language "C++"		-- 사용 언어

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")	-- 생성파일(exe, lib, dll) 경로설정
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")	-- obj 파일경로 설정

	files	-- 어떤 파일들을 컴파일 할 것인지?
	{
		"%{prj.name}/src/**.h",		-- 프로젝트 이름 폴더 -> src 폴더 안에 있는 모든 헤더파일들
		"%{prj.name}/src/**.cpp"	-- 위와 동일한 경로에 있는 cpp 파일들
	}

	includedirs		-- 추가 포함 디렉토리 경로 설정
	{
		"%{prj.name}/vendor/spdlog/include"	-- 사진 2 참조
	}

	filter "system:windows"		-- 특정환경에 대한 설정 (ex. window 환경)
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"		-- 10.0 또는 latest 사용하여 윈도우버전을 최신으로 설정. 사진 3 참조. 

		defines		-- 전처리기 설정. 사진 1 참조.
		{
			"HZ_PLATFORM_WINDOWS",		-- Hazel 프로젝트에는 이러한 전처리가 있다.
			"HZ_BUILD_DLL"
		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
			-- hazel 디렉터리에 있는 dll 파일을 sandbox 디렉터리에 복사해주는 명령
		}

	filter "configurations:Debug"	-- 디버그 구성일 때 설정
		defines "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"	-- 릴리즈일때..
		defines "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"		-- dist 구성일 때..
		defines "HZ_DIST"
		optimize "On"

project "SandBox"		-- 프로젝트 이름 (작성시점 기준 솔루션 안에는 Hazel과 SandBox 프로젝트가 있다.)
	location "SandBox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Hazel/vendor/spdlog/include",	-- 사진 2 참조
		"Hazel/src"		-- Hazel.h 를 인클루드
	}

	links
	{
		"Hazel"		-- 링크할 프로젝트를 적는다.
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines		-- 사진 1 참조
		{
			"HZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		optimize "On"
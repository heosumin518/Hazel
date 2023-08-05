-- lua�� "--" �� �ּ��̴�.

workspace "Hazel"		-- �ַ�� ���� �̸�
	architecture "x64"	-- �ַ���� architecture, 64bit �� ����

	configurations		-- ���� (debug ���, release ��� �� � ������ �ִ���?)
	{
		"Debug",
		"Release",
		"Dist"
	}

-- ����� ���� ��θ� outputdit ������ ����
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"			-- ������Ʈ �̸�
	location "Hazel"
	kind "SharedLib"	-- ���� �� �����Ǵ� ������ ���� (ex. ��������(exe)���� ���̺귯��(lib or dll)����
	language "C++"		-- ��� ���

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")	-- ��������(exe, lib, dll) ��μ���
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")	-- obj ���ϰ�� ����

	files	-- � ���ϵ��� ������ �� ������?
	{
		"%{prj.name}/src/**.h",		-- ������Ʈ �̸� ���� -> src ���� �ȿ� �ִ� ��� ������ϵ�
		"%{prj.name}/src/**.cpp"	-- ���� ������ ��ο� �ִ� cpp ���ϵ�
	}

	includedirs		-- �߰� ���� ���丮 ��� ����
	{
		"%{prj.name}/vendor/spdlog/include"	-- ���� 2 ����
	}

	filter "system:windows"		-- Ư��ȯ�濡 ���� ���� (ex. window ȯ��)
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"		-- 10.0 �Ǵ� latest ����Ͽ� ����������� �ֽ����� ����. ���� 3 ����. 

		defines		-- ��ó���� ����. ���� 1 ����.
		{
			"HZ_PLATFORM_WINDOWS",		-- Hazel ������Ʈ���� �̷��� ��ó���� �ִ�.
			"HZ_BUILD_DLL"
		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
			-- hazel ���͸��� �ִ� dll ������ sandbox ���͸��� �������ִ� ���
		}

	filter "configurations:Debug"	-- ����� ������ �� ����
		defines "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"	-- �������϶�..
		defines "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"		-- dist ������ ��..
		defines "HZ_DIST"
		optimize "On"

project "SandBox"		-- ������Ʈ �̸� (�ۼ����� ���� �ַ�� �ȿ��� Hazel�� SandBox ������Ʈ�� �ִ�.)
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
		"Hazel/vendor/spdlog/include",	-- ���� 2 ����
		"Hazel/src"		-- Hazel.h �� ��Ŭ���
	}

	links
	{
		"Hazel"		-- ��ũ�� ������Ʈ�� ���´�.
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines		-- ���� 1 ����
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
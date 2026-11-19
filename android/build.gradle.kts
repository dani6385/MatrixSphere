// 1. Konfigurasi buildscript untuk AGP 9.1.1
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:9.1.1")
    }
}

// 2. Repositori bersama untuk seluruh project dan subproject
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 3. Memusatkan folder build di luar direktori android (../../build)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// 4. Menyelaraskan direktori build dan compileSdk subproject Android
val targetCompileSdk = 36

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val setCompileSdk = androidExt.javaClass.getMethod(
                    "setCompileSdk",
                    Int::class.java
                )
                setCompileSdk.invoke(androidExt, targetCompileSdk)
            } catch (_: Exception) {
                try {
                    val setCompileSdkVersion = androidExt.javaClass.getMethod(
                        "setCompileSdkVersion",
                        Int::class.java
                    )
                    setCompileSdkVersion.invoke(androidExt, targetCompileSdk)
                } catch (_: Exception) {
                    // Lewati dengan aman jika modul bukan ekstensi Android standar
                }
            }
        }
    }
}

// 5. Pastikan :app dievaluasi lebih dulu jika dibutuhkan subproject
subprojects {
    project.evaluationDependsOn(":app")
}

// 6. Task clean untuk membersihkan folder build gabungan
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
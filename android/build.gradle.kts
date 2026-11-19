buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:9.1.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

val targetCompileSdk = 36

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        val androidExt = extensions.findByName("android")
        if (androidExt != null) {
            try {
                val setCompileSdk = androidExt.javaClass.getMethod(
                    "compileSdk",
                    Int::class.javaPrimitiveType
                )
                setCompileSdk.invoke(androidExt, 35)
            } catch (_: Exception) {
                try {
                    val setCompileSdkVersion = androidExt.javaClass.getMethod(
                        "setCompileSdkVersion",
                        Int::class.javaPrimitiveType
                    )
                    setCompileSdkVersion.invoke(androidExt, 35)
                } catch (_: Exception) {
                    // Abaikan jika subproject bukan modul Android yang mendukung setter ini
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

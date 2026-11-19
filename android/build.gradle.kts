// 1. Letakkan buildscript di BAGIAN PALING ATAS file
buildscript {
    val kotlin_version by extra("1.9.24")
    
    repositories {
        google()
        mavenCentral()
    }
    
    dependencies {
        // Tambahkan classpath plugin Android Gradle atau Kotlin di sini jika diperlukan
        // Contoh: classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

// 2. Setelah itu baru diikuti oleh konfigurasi allprojects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 3. Konfigurasi direktori build kustom untuk monorepo
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory =
        newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 4. Task clean di bagian bawah
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

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

// 4. Mengatur direktori build tiap subproject di monorepo
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 5. Memastikan :app dievaluasi sebelum subproject lain
subprojects {
    if (project.path != ":app") {
        project.evaluationDependsOn(":app")
    }
}

// 6. Task clean untuk membersihkan folder build gabungan
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
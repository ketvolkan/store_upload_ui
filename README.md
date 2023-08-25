
# Flutter Upload CI Tool
[EN]
It is a continuous integration tool that allows you to manage the attached Fastlanes in your project collectively.

[TR]
Projedeki ekli olan Fastlane'ları toplu bir şekilde yönetmenizi sağlayan bir sürekli entegrasyon aracıdır.


## Usage
[EN]
1. Step : Firstly, you need to add a new project file by clicking on the (+) icon located at the bottom right.
2. Step : After selecting the project, if there are multiple branches, you need to choose which branch you will be working on.
3. Step : Once your project is successfully added, all you have to do is enter the version number, select android and ios options as you desire, and press the "upload" button.
   
[TR]
1. Adım: İlk olarak, sağ alt köşedeki (+) simgesine tıklayarak yeni bir proje dosyası eklemeniz gerekmektedir.
2. Adım: Projeyi seçtikten sonra, eğer birden fazla dal (branch) varsa işlem yapmak istediğiniz dalı seçmeniz gerekiyor.
3. Adım: Projeniz başarıyla ekledikten sonra, yapmanız gereken tek şey versiyon numarasını girmek, ardından android ve ios seçeneklerini istediğiniz gibi ayarlayıp "upload" düğmesine basmaktır.
   
![Ekran Resmi 2023-08-25 11 12 50](https://github.com/ketvolkan/store_upload_ui/assets/80161667/4512c515-a278-4568-ae66-5486aeb134a5)
![Ekran Resmi 2023-08-25 11 13 40](https://github.com/ketvolkan/store_upload_ui/assets/80161667/b20c843e-09be-43ec-a6e2-5cbfea9de349)
![Ekran Resmi 2023-08-25 11 13 06](https://github.com/ketvolkan/store_upload_ui/assets/80161667/be9ebcbb-cf06-477c-bd28-b2d671808d21)
![Ekran Resmi 2023-08-25 11 12 58](https://github.com/ketvolkan/store_upload_ui/assets/80161667/d80b87b4-e7a6-432e-83ba-b5506e5d5d41)


  ## Fastlane Entegration
### Android
```ruby

default_platform(:android)
ENV_PATH = "../assets/app/.env"
ANDROID_VERSION_NAME = "androidVersionName"
APP_BUNDLE_PATH = "../build/app/outputs/bundle/release/app-release.aab"
INTERNAL = "internal"
PRODUCTION = "production"
APK_PATH = "../build/app/outputs/flutter-apk/app-release.apk"
CHANGE_LOG_PATH = "./metadata/android/tr-TR/changelogs/54.txt"
HUAWEI_APP_ID = "huaweiAppId"
HUAWEI_CLINT_ID = "huaweiClintId"
HUAWEI_CLINT_SECRET = "huaweiClintSecret"


platform :android do
  desc "Deploy to internal test application"
  lane :internal do |options|
  versionCodeArray = google_play_track_version_codes(track:INTERNAL)
  releaseNameArray = google_play_track_release_names(track:PRODUCTION)
  versionNumber = (versionCodeArray.length > 0 ? versionCodeArray[0] : 0).to_i + 1
  releaseName = (releaseNameArray.length > 0 ? releaseNameArray[0] : 0)
  versionCode = flutter_version()["version_code"]; # pubspec.yaml dan alır
  setVersionName(releaseName)
  incerementVersion version: options[:version]
  setVersionNumber versionNumber: options[:versionNumber]
  #versionName = getVersionName()
  flutter_build(versionCode,versionNumber)
  buildStore(INTERNAL)
  gitTag(versionNumber,versionCode)
  end

  desc "Test fastlane line no publish"
  lane :test do |options|
     versionCodeArray = google_play_track_version_codes(track:INTERNAL)
     increment_version_to_pubspec()
     releaseNameArray = google_play_track_release_names(track:PRODUCTION)
     versionNumber = (versionCodeArray.length > 0 ? versionCodeArray[0] : 0).to_i + 1
     releaseName = (releaseNameArray.length > 0 ? releaseNameArray[0] : 0)
     setVersionName(releaseName)
     versionCode = flutter_version()["version_code"]; # pubspec.yaml dan alır
     incerementVersion version: options[:version]
     setVersionNumber versionNumber: options[:versionNumber]
    versionName = getVersionName()
    flutter_build(versionCode,versionNumber)

  end



    def flutter_build(versionName, number)
        Dir.chdir '../../' do
            sh("flutter", "clean")
            sh("flutter", "packages", "get")
            sh("flutter build appbundle --build-number=#{number.to_s} --no-tree-shake-icons")
            sh("flutter build apk --build-number=#{number.to_s} --no-tree-shake-icons")
        end
    end

    def buildStore(track)
        upload_to_play_store(
              track: track,
              release_status: 'completed',
              aab: APP_BUNDLE_PATH,
              skip_upload_metadata: 'true',
              skip_upload_images: 'true',
              skip_upload_screenshots: 'true',
              )
        huawei_appgallery_connect(
              client_id:  getHuaweiClintId(),
              client_secret:  getHuaweiClintSecret(),
              app_id: getHuaweiAppId(),
              apk_path: APK_PATH,
              is_aab: false,
              submit_for_review: false, #TODO True yapılacak
              changelog_path: CHANGE_LOG_PATH,
              release_time: "2024-12-25T07:05:15+0000"
              )
    end

    def gitTag(build_number,versionName)

        add_git_tag(
          grouping: "builds",
          includes_lane: false,
          prefix: versionName + '+',
          build_number:build_number,
        )
        sh("git push --tags")
    end

    def increment_version_to_pubspec()
      Dir.chdir '../../../salonrandevu/utilities' do
          sh("dart","run","increment_version.dart")
    end
  end


    private_lane :setVersionNumber do |options|
      if options[:versionNumber] != nil
       set_properties_value(
        key: ANDROID_VERSION_NAME,
        path: ENV_PATH,
        value: options[:versionNumber]
        )
     end
    end

    private_lane :incerementVersion do |options|
       if options[:version] != nil
        increment_version_name_in_properties_file(
         key: ANDROID_VERSION_NAME,
         path: ENV_PATH,
         update_type: options[:version]
         )
       end
    end


    def setVersionName(versionName)
      if versionName != 0
        set_properties_value(
          key: ANDROID_VERSION_NAME,
          path: ENV_PATH,
          value: versionName
          )
      end
    end

    def getVersionName
      return get_properties_value(
        key: ANDROID_VERSION_NAME,
        path: ENV_PATH
       )
    end

    def getHuaweiAppId
      return get_properties_value(
        key: HUAWEI_APP_ID,
        path: ENV_PATH
       )
    end

    def getHuaweiClintId
      return get_properties_value(
        key: HUAWEI_CLINT_ID,
        path: ENV_PATH
       )
    end

    def getHuaweiClintSecret
      return get_properties_value(
        key: HUAWEI_CLINT_SECRET,
        path: ENV_PATH
       )
    end

end

```
### Ios
```ruby

default_platform(:ios)
IOSKEYJSON = "./key/fastlane_ios.json"

platform :ios do

    desc "Test function matching and app build. not publish"
    lane :test do |options|
        buildNumber = latest_testflight_build_number
        incrementBuildNumber(buildNumber)
        incrementVersionNumber(options[:version])
        build_app(workspace: "Runner.xcworkspace", scheme: "Runner")
    end

    desc "Push a new beta build to TestFlight"
    lane :beta do |options|
       buildNumber = latest_testflight_build_number
       incrementBuildNumber(buildNumber)
       incrementVersionNumber(options[:version])
       build_app(workspace: "Runner.xcworkspace", scheme: "Runner")
       upload_to_testflight(api_key_path: IOSKEYJSON,skip_waiting_for_build_processing: true)
    end


    desc "Push a new release build to AppStore"
    lane :release do |options|
        buildNumber = latest_testflight_build_number
        incrementBuildNumber(buildNumber)
        incrementVersionNumber(options[:version])
        build_app(workspace: "Runner.xcworkspace", scheme: "Runner")
        upload_to_app_store( api_key_path: "./key/fastlane_ios.json")
    end


    def incrementBuildNumber(val)
        if val != nil
          increment_build_number({build_number: val + 1})
        end
      end


      def incrementVersionNumber(val)
        if val != nil
          $version_number = increment_version_number(bump_type: val)
        end
      end
end

```
### Assets->App->.env
[En]
Huawei values allow you to release versions through AppGallery as well. You can obtain the following values from AppGallery Connect.

[TR]
Huawei değerleri, AppGallery üzerinden de versiyon atabilmenizi sağlar. Aşağıdaki değerleri AppGallery Connect üzerinden alabilirsiniz.
```.env
androidVersionName=255(4.1.2)
huaweiAppId=[HUAWEI APP ID]
huaweiClintId=[HUAWEI CLINT ID]
huaweiClintSecret=[HUAWEI CLINT SECRET]
```
## NOTE
[EN]To see the branches in the project, it is necessary to switch to that branch and pull it to your local machine beforehand.

[TR]
Branchleri görmesi için proje üzerinde daha önceden o branch'e geçip local'e çekilmesi gerekiyor.


  
## Projeyi oluşturanlar

- [@smhoz](https://www.github.com/smhoz)
- [@ketvolkan](https://www.github.com/ketvolkan)

  

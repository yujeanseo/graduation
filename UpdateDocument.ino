
/**
 * Created by K. Suwatchai (Mobizt)
 *
 * Email: k_suwatchai@hotmail.com
 *
 * Github: https://github.com/mobizt/Firebase-ESP-Client
 *
 * Copyright (c) 2023 mobizt
 *
 */

// This example shows how to patch or update a document in a document collection. This operation required Email/password, custom or OAUth2.0 authentication.

#include <Arduino.h>
#if defined(ESP32) || defined(ARDUINO_RASPBERRY_PI_PICO_W)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#elif __has_include(<WiFiNINA.h>)
#include <WiFiNINA.h>
#elif __has_include(<WiFi101.h>)
#include <WiFi101.h>
#elif __has_include(<WiFiS3.h>)
#include <WiFiS3.h>
#endif

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "yujin"
#define WIFI_PASSWORD "234567890"

/* 2. Define the API Key */
#define API_KEY "AIzaSyDGlaP5hmoh4qj9xsbR5HtcybGBsErZaEk"

/* 3. Define the project ID */
#define FIREBASE_PROJECT_ID "workermanager-803df"

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "yujinseo0313@gmail.com"
#define USER_PASSWORD "123456"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;

bool taskcomplete = false;

int shock = 0; 
double temperature = 37.0; 
double longitude = 127.1045; 
double latitude = 37.5135; 

const int shockSensorPin = 4; // 충격 센서 핀
volatile bool shockDetected = false; // 충격 감지 플래그

// 충격 감지 인터럽트 핸들러
void IRAM_ATTR handleShockInterrupt() {
  shockDetected = true; // 충격이 감지되면 플래그 설정
}

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
WiFiMulti multi;
#endif

void setup()
{

    Serial.begin(115200);

    pinMode(shockSensorPin, INPUT); // 충격 센서 핀을 입력으로 설정

    // 충격 센서 핀에 외부 인터럽트 설정 (상황에 따라 RISING이나 FALLING으로 설정)
    attachInterrupt(digitalPinToInterrupt(shockSensorPin), handleShockInterrupt, FALLING);

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    multi.addAP(WIFI_SSID, WIFI_PASSWORD);
    multi.run();
#else
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
#endif

    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
        if (millis() - ms > 10000)
            break;
#endif
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = API_KEY;

    /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    // The WiFi credentials are required for Pico W
    // due to it does not have reconnect feature.
#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    config.wifi.clearAP();
    config.wifi.addAP(WIFI_SSID, WIFI_PASSWORD);
#endif

    /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
    Firebase.reconnectNetwork(true);

    // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
    // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
    fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

    // Limit the size of response payload to be collected in FirebaseData
    fbdo.setResponseSize(2048);

    Firebase.begin(&config, &auth);

    // You can use TCP KeepAlive in FirebaseData object and tracking the server connection status, please read this for detail.
    // https://github.com/mobizt/Firebase-ESP-Client#about-firebasedata-object
    // fbdo.keepAlive(5, 5, 1);
}

void loop()
{

    // Firebase.ready() should be called repeatedly to handle authentication tasks.

    if (Firebase.ready() && (millis() - dataMillis > 60000 || dataMillis == 0))
    {
        dataMillis = millis();

        // For the usage of FirebaseJson, see examples/FirebaseJson/BasicUsage/Create_Edit_Parse/Create_Edit_Parse.ino
        FirebaseJson content;

        // aa is the collection id, bb is the document id.
        String documentPath = "esp32_device/device_8";  // aa 컬렌션에 bb 문서에 데이터 업뎃

        // If the document path contains space e.g. "a b c/d e f"
        // It should encode the space as %20 then the path will be "a%20b%20c/d%20e%20f"

        if (!taskcomplete)  // 없는 문서면 생성, 이미 있는 문서면 if문 넘겨서 업뎃 
        {
            taskcomplete = true;

            content.clear();

            content.set("fields/count/integerValue", String(count).c_str());  //얘랑
            content.set("fields/status/booleanValue", count % 2 == 0);  //얘는
            // 값이 계속 변하고 있는지 확인하려고 넣어놓은 것

            content.set("fields/shock/stringValue", String(shock).c_str());  // 충격값

            content.set("fields/temperature/stringValue", String(temperature).c_str());  //체온
            content.set("fields/longitude/stringValue", String(longitude, 4).c_str());  //위도경도
            content.set("fields/latitude/stringValue", String(latitude, 4).c_str());  //위도경도


            Serial.print("Create a document... ");

            if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw()))
                Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
            else
                Serial.println(fbdo.errorReason());
        }

        count++;
        

        //--------------------------------------------------------------------------- 충격 감지 여부 확인 및 Firebase 업데이트
        if (shockDetected) {
            shock++;
            shockDetected = false; // 플래그를 초기화
        }//---------------------------------------------------------------------------충격 감지 여부 확인 및 Firebase 업데이트 여기서 값을 올릴거임
        content.clear();

        content.set("fields/count/integerValue", String(count).c_str());  //얘랑
        content.set("fields/status/booleanValue", count % 2 == 0);  //얘는
        // 값이 계속 변하고 있는지 확인하려고 넣어놓은 것

        content.set("fields/shock/stringValue", String(shock).c_str());  // 충격값

        content.set("fields/temperature/stringValue", String(temperature).c_str());  //체온
        content.set("fields/longitude/stringValue", String(longitude, 4).c_str());  //위도경도
        content.set("fields/latitude/stringValue", String(latitude, 4).c_str());  //위도경도


        Serial.print("Update a document... ");

        /** if updateMask contains the field name that exists in the remote document and
         * this field name does not exist in the document (content), that field will be deleted from remote document
         */


        // ********** if문 안에 업데이트 하고 싶은 필드명 다 넣어놔야 업데이트 된다*************
        if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "" /* databaseId can be (default) or empty */, documentPath.c_str(), content.raw(), "count,status,shock,temperature,longitude,latitude" /* updateMask */))
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
        else
            Serial.println(fbdo.errorReason());
    }
}
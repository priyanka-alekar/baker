//
//  Constants.h
//  Baker
//
//  ==========================================================================================
//
//  Copyright (c) 2010-2012, Davide Casali, Marco Colombo, Alessandro Morandi
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this list of
//  conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of
//  conditions and the following disclaimer in the documentation and/or other materials
//  provided with the distribution.
//  Neither the name of the Baker Framework nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written
//  permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#ifndef Baker_Constants_h
#define Baker_Constants_h

    // ----------------------------------------------------------------------------------------------------
    // NEWSSTAND SUPPORT
    // The following line, together with other settings, enables Newsstand code.
    // Remove this, remove the NewsstandKit.framework and the Newsstand entries in Baker-Info.plist to disable it.
    // See: https://github.com/Simbul/baker/wiki/Newsstand-vs-Bundled-publications-support-in-Baker-4.0
    #define BAKER_NEWSSTAND

    #ifdef BAKER_NEWSSTAND

        // Remove the following line once you complete the Newsstand setup below.
        #warning Newsstand: Remember to set the AppStore/Newsstand constants and delete this line once you did it.

        #warning Newsstand: NIN9 Creative - I left  my definition here so that developers could run out of the box.  Obviously change it!
        // ----------------------------------------------------------------------------------------------------
        // Mandatory - This constant defines where the JSON file containing all the publications is located.
        // For more information on this file, see: https://github.com/Simbul/baker/wiki/Newsstand-shelf-JSON
        // E.g. @"http://example.com/books.json"
        #define NEWSSTAND_MANIFEST_URL @"http://api.newsstandadmin.com/issues/abe6d7fa-12e8-427e-b690-5b8e977dd8d1"

        #warning Newsstand: NIN9 Creative - I left  my definition here so that developers could run out of the box.  Obviously change it!
        // ----------------------------------------------------------------------------------------------------
        // Mandatory - This constant identifies the subscription you set up in iTunesConnect.
        // See: iTunes Connect -> Manage Your Application -> (Your application) -> Manage In App Purchases
        // E.g. @"com.example.MyBook.subscription.free"
        #define PRODUCT_ID_FREE_SUBSCRIPTION @"com.nin9creative.bakershelf.sub.free"

        // ----------------------------------------------------------------------------------------------------
        // Optional - This constant specifies the URL to ping back when a user subscribes.
        // E.g. @"http://example.com/subscribe"
        #define PURCHASE_CONFIRMATION_URL @""

    #endif

    // ----------------------------------------------------------------------------------------------------
    // PARSE.COM SUPPORT
    // The following line, together with other settings, enables Parse.com integration.  This is mainly used
    // for Push Notifications.
    #define PARSE_SUPPORT

    #warning Newsstand: NIN9 Creative - I left  my definition here so that developers could run out of the box.  Obviously change it!
    #ifdef PARSE_SUPPORT

        #define PARSE_APPLICATION_ID @"CFTto7CKHLA9uvDbJJemIFkTdghZw3RGaVrIcfEY"
        #define PARSE_CLIENT_KEY @"Gms8URmvh35yahScD66b0B6be8YAWvCIPJ1GCMew"

    #endif

    // ----------------------------------------------------------------------------------------------------
    // GOOGLE ANALYTICS SUPPORT
    // The following line, together with other settings, enables Google Analytics integration.
    // For more information on setting this up...
    // See: https://developers.google.com/analytics/devguides/collection/ios/devguide#howItWorks
    #define GOOGLE_ANALYTICS

    #warning Newsstand: NIN9 Creative - I left  my definition here so that developers could run out of the box.  Obviously change it!
    #ifdef GOOGLE_ANALYTICS

        #define GOOGLE_WEB_PROPERTY_ID @"UA-36565388-1"
        #define GOOGLE_DISPATCH_PERIOD_SECONDS 90

    #endif

    // ----------------------------------------------------------------------------------------------------
    // INFO VIEW SUPPORTED
    // The following line Enables or Disables the Info / About View
    #define INFO_VIEW


#endif

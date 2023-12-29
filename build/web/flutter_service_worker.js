'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "9ee7b46e48e3010a397a791aef382826",
"assets/AssetManifest.bin.json": "52fb4688a71da57eff06631d693cd5c0",
"assets/AssetManifest.json": "db0c04d8a1274e803b8a7bb19f88e560",
"assets/assets/images/advertencia.png": "9ae683f00f766662fb5e9ebe4c1f77b4",
"assets/assets/images/anime.png": "92de4fbfa8a4b389b58679bfb9a15854",
"assets/assets/images/facebook.png": "5c3a388b25669b218bdb49c1c4156ce5",
"assets/assets/images/google_icon.png": "ed9a66619ee1e09cd4c18ac806edbc41",
"assets/assets/images/groceries.png": "669f8e6be0c3c2e7111081e286a7ea83",
"assets/assets/images/one_punch.jpg": "90cf8cf462f729b1295da59d69581d3c",
"assets/assets/images/warning-sign.png": "984c47c9fac447b0183fa9c917777a7c",
"assets/FontManifest.json": "9ee548a5be803eea4cd8dc712d80fb39",
"assets/fonts/MaterialIcons-Regular.otf": "4d3a6e62dde14bbeb64235448721d034",
"assets/iconos/advertencia.png": "7eda9e72318b27d3396837cf8efe9bdf",
"assets/iconos/carrito-de-compras.png": "c2c43cd990cdaf24099534fb346468ff",
"assets/iconos/cerrar-sesion.png": "700956143ea669b595bd93dd39c1f886",
"assets/iconos/comentarios.png": "15a3953defa62d180c2c109388ccbc0b",
"assets/iconos/configuraciones.png": "c2fd49b3da8420a16fc63546eb5d7670",
"assets/iconos/descargar.png": "9386204fa729bd523632dfced4fa2187",
"assets/iconos/ejemploPerfil.png": "1d36af2bb4927a8483ae8d4ca7721d18",
"assets/iconos/facebook.png": "00c27c23de388f6efe741b8a530e1846",
"assets/iconos/favorito.png": "65c6a9eb7d00fc868edbc232af0f2b41",
"assets/iconos/favorito2.png": "f2c883a827cc1971e022d10a1f9e3f50",
"assets/iconos/google.png": "5dfe8a55300ec4a98d06bf778fd1b769",
"assets/iconos/guardar.png": "76d6b70d95b68a07d50b75d79143e03c",
"assets/iconos/hospital.png": "bc238e5e228639feb7fc9eb676584beb",
"assets/iconos/hotel.png": "866bf910ad0b564c378d0a055fc04fa9",
"assets/iconos/iconoComedia.png": "571cebb34a5c06c38680a47d1a678477",
"assets/iconos/iconoEscolar.png": "41273abb103214e8f4c11b18f67f8425",
"assets/iconos/iconoGore.png": "59ba49ed698da163207515f053646109",
"assets/iconos/iconoMisterio.png": "f66575329248ea59bd40b5a2fd062b30",
"assets/iconos/iconoRomance.png": "8919a4f6c060fd409fa78936a6e0a3df",
"assets/iconos/iconoShonen.png": "5d5cbe4b23dafe4cf9cd67ab8d4dab2e",
"assets/iconos/inicio.png": "9d62ab105e7c0fd91299037c0c2ff6d0",
"assets/iconos/lista.png": "1e0bb73e405947cd1272e3dd88a7abc7",
"assets/iconos/puntuacion.png": "3f1bb9336539f7dfd9e632bf555d5369",
"assets/iconos/tienda.png": "1bf34e6a9d5a0bffc0d6ea8b1f5a5143",
"assets/iconos/usuario.png": "e3715ec92edbbbe6a83936af85099e50",
"assets/images/anime1.jpg": "35a45b4ce5ffc60d783bf299edf69827",
"assets/images/anime10.jpg": "fc5113bf76ed54610e22f3e9c834a3cd",
"assets/images/anime11.jpg": "df9eb89268a98f1274dccc7c0b63094a",
"assets/images/anime12.jpg": "2c63bbfb20c3532ad900dc01522722ea",
"assets/images/anime13.jpg": "a3734eba515a453ac92e30417c279a74",
"assets/images/anime14.jpg": "893cacd944dff99bfd27f00544891845",
"assets/images/anime15.jpg": "1b2bcca2bc9f3b0b1b5d7f68cefdf84e",
"assets/images/anime2.jpg": "a1c4cdb16ed7f3cc15d7f48e59860497",
"assets/images/anime3.jpg": "3663c6f0db02592fcf2927f45f2ef242",
"assets/images/anime4.jpg": "f7dd9db5bbc651dc73cb4ad62a7ca0a6",
"assets/images/anime5.jpg": "2335243425a120fa4c9785f64963277e",
"assets/images/anime6.jpg": "e0a7fd2e86bf44c37b1ebd580569f764",
"assets/images/anime7.jpg": "e59cec5cc3ad846a3ad07b7ab185d3a0",
"assets/images/anime8.jpg": "d85eaa7f28a9496b733177786ba433ae",
"assets/images/anime9.jpg": "b84304d3a235f8c5a918fa11d5d22670",
"assets/images/baki.JPG": "1e5fbf92b75b709128879b0767b646a0",
"assets/images/caja.png": "bea2828b8eedad050d8176e422b074fa",
"assets/images/carrito-de-compras.png": "c2c43cd990cdaf24099534fb346468ff",
"assets/images/cartero.png": "a906632847215c73596db451b356d0fa",
"assets/images/claymore.jpg": "418257f063444c063943d8d6db5fe878",
"assets/images/cosplay.png": "5f8eb93306ba8eb791025cefad7ed148",
"assets/images/dragon%2520ball%2520gt%2520portada.JPG": "0211576fe342ea8cacd339770a6f21a9",
"assets/images/fantasma.png": "e01f42b7585f7a79fe7c51f7b5b020b1",
"assets/images/fondoCarga.jpg": "3c9c9fb27db1d3949bdfd034a9de9912",
"assets/images/fondoCarga2.jpg": "8213ab16ffde58d25d044d9cd1444f6d",
"assets/images/fondoCarga3.jpg": "7c5bc89c4a3d6924081cdfa1085eab29",
"assets/images/fondoCarga4.jpg": "88530f027b4004d531a033ba1e854934",
"assets/images/fondoCarga5.jpg": "02b5e01f4fa4edfd0696bbc86d49d1cf",
"assets/images/fondoCarga6.jpg": "1010d5bc29d636ef1aa2da7f8bee0ae2",
"assets/images/fondoCarga7.jpg": "216b86df7bd95a094461a875ae906da1",
"assets/images/fondoInicio.jpg": "f2015ab398521209cb4f921d6ce7cd4a",
"assets/images/fondoInicio2.jpg": "941833d7dcbea990b4981307d01f4439",
"assets/images/fondoInicio3.jpg": "07203c4b8fbb12a79ec4503e446dca2c",
"assets/images/fondoInicio4.jpg": "d8cdb160e259a1b668ca31b44853540b",
"assets/images/historietas.png": "dfbd873fdd361a433b889259d4add00e",
"assets/images/kengan%2520ashura.jpg": "7a01c7b60df9bf26f1ce954bd7387142",
"assets/images/libro-de-historietas.png": "22b2e0781b78f160c7712ef9e7642380",
"assets/images/lista-de-deseos.png": "e35de3a5957c528e8464ea9f8f24c340",
"assets/images/manga11_DB_super.JPG": "25db09e761d714472dd607d6a942a703",
"assets/images/manga12_DB_super.jpg": "2539fe66f9aee9ced45214740b2e383e",
"assets/images/manga13_DB_super.jpg": "3657790e19f5cd527e175ca5039bf9cf",
"assets/images/mangas/gore/chainsawman.jpg": "1d07dbfef45e4fa383d667fe0d5f98a5",
"assets/images/mangas/gore/claymore.jpg": "f24196cc525c9af07f874047faa78e4d",
"assets/images/mangas/gore/elfen%2520lied.jpg": "fc4e57dff783ac91b7c9e5087d5f325d",
"assets/images/mangas/romance/Angel%2520Beats.jpg": "a80e9baab0adc410c724e6c8e2124cb2",
"assets/images/mangas/romance/clannad.jpg": "06e045c996d1342b8332a3f54b6fefba",
"assets/images/mangas/romance/Sukitteiinayo.jpg": "29c3c3156cf2bc99c05db2516e151d0c",
"assets/images/mangas/shonen/dragon_ball_super.jpg": "54f24f9aadb4621c4cd4c3d3f06b98aa",
"assets/images/mangas/shonen/mangaNaruto.jpg": "109746530fa144ac1927c513855b2585",
"assets/images/mangas/shonen/Naruto.jpg": "98d32a24c1785d150f5afd6e1c717d4b",
"assets/images/mangas/shonen/One%2520Piece.jpe": "7064e390f698afa6cee27742f26a8463",
"assets/images/one_punch_man.JPG": "15ccca65eab5383085f02851b9fab14a",
"assets/images/otaku.png": "cad714bdf054f0e49b6b65faa43d78b5",
"assets/images/polluelo.png": "5eab76041a1c8e3f7e7e42852bff7e6b",
"assets/images/reno.png": "075ea47b842d3a2c77ac657465fcb463",
"assets/images/saint%2520seiya%2520soul%2520of%2520gold.jpg": "d98e4c0df078b3aa908f401d997e0a80",
"assets/images/ver-la-television.png": "43d73f904204fdfce3d51e5a38c6d593",
"assets/NOTICES": "991b034798289b35bed3db69eb60c480",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/iconly/fonts/IconlyBold.ttf": "6c73fc0a864250644f562a679591e0a4",
"assets/packages/iconly/fonts/IconlyBroken.ttf": "ae60c99d5cf25644beb25a87577bf6ca",
"assets/packages/iconly/fonts/IconlyLight.ttf": "baf08d3e753c86f1bdacb3535d66e2aa",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "f1ad8039a50409f0dbdd0e75aba6f3b7",
"/": "f1ad8039a50409f0dbdd0e75aba6f3b7",
"main.dart.js": "36a27ce47d896dbc2c2398b4f715f60c",
"manifest.json": "67f0da846169fdb6d6bfdee118f7d269",
"version.json": "a955031f6ac4f1cd424d48aca90c7236"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

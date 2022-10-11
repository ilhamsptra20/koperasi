<?php

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
Route::get('/pusat', [HomeController::class, 'index'])->middleware('auth', 'admin.pusat');
Route::get('/cabang', [HomeController::class, 'index'])->middleware('auth', 'admin.cabang');
Route::get('/anggota', [HomeController::class, 'index'])->middleware('auth', 'admin.anggota');
Route::get('/anonymous', [HomeController::class, 'index'])->middleware('auth', 'anonymous');
Route::get('/defaultuser', [HomeController::class, 'index'])->middleware('auth', 'default.user');
Route::get('/administrator', [HomeController::class, 'index'])->middleware('auth', 'administrator');

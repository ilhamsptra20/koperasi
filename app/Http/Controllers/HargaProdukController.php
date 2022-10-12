<?php

namespace App\Http\Controllers;

use App\Models\HargaProduk;
use Illuminate\Http\Request;

class HargaProdukController extends Controller
{
    public function index()
    {
        $hargaProduk = HargaProduk::get();
        return view('hargaproduk', compact('hargaProduk'));
    }

    public function create()
    {
        return view('hargaproduk');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'idPlace' => 'required',
            'idProduk' => 'required',
            'mulaiEfektif' => 'required',
            'selesaiEfektif' => 'required',
            'hargaBeli' => 'required',
            'markUp' => 'required',
            'hargaJual' => 'required',
            'catatan' => 'required',
        ]);

        HargaProduk::create($data);

        return back();
    }

    public function show(HargaProduk $hargaProduk)
    {
        return view('hargaproduk', compact('hargaProduk'));
    }
    
    public function edit(HargaProduk $hargaProduk)
    {
        return view('hargaproduk', compact('hargaProduk'));
    }

    public function update(Request $request, HargaProduk $hargaProduk)
    {
        $data = $request->validate([
            'idPlace' => 'required',
            'idProduk' => 'required',
            'mulaiEfektif' => 'required',
            'selesaiEfektif' => 'required',
            'hargaBeli' => 'required',
            'markUp' => 'required',
            'hargaJual' => 'required',
            'catatan' => 'required',
        ]);

        $hargaProduk->update($data);

        return back();
    }

    public function delete(HargaProduk $hargaProduk)
    {
        $hargaProduk->delete();
        return back();
    }
}

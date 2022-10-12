<?php

namespace App\Http\Controllers;

use App\Models\SatuanProduk;
use Illuminate\Http\Request;

class SatuanProdukController extends Controller
{
    public function index()
    {
        $satuanProduk = SatuanProduk::get();
        return view('tampilan', compact('satuanProduk'));
    }

    public function create()
    {
        return view('tampilan');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'idProduk' => 'required',
            'satuan' => 'required',
            'qtyBalance' => 'required',
            'haveChild' => 'required',
            'qtyChild' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        SatuanProduk::create($data);

        return back()->with('success', 'data berhasil ditambahkan');
    }

    public function show(SatuanProduk $satuanProduk)
    {
        return view('tampilan', compact('satuanProduk'));
    }
    
    public function edit(SatuanProduk $satuanProduk)
    {
        return view('tampilan', compact('satuanProduk'));
    }

    public function update(Request $request, SatuanProduk $satuanProduk)
    {
        $data = $request->validate([
            'idProduk' => 'required',
            'satuan' => 'required',
            'qtyBalance' => 'required',
            'haveChild' => 'required',
            'qtyChild' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        $satuanProduk->update($data);

        return back()->with('success', 'data berhasil diubah');
    }

    public function delete(SatuanProduk $satuanProduk)
    {
        $satuanProduk->delete();
        return back()->with('success', 'data berhasil dihapus');
    }
}


<?php

namespace App\Http\Controllers;

use App\Models\Produk;
use Illuminate\Http\Request;

class ProdukController extends Controller
{
    public function index()
    {
        $produk = Produk::get();

        return view('produk.index', compact('produk'));
    }

    public function create()
    {
        return view('produk.create');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'kodeProduk' => 'required',
            'nama' => 'required',
            'jenisProduk' => 'required',
            'sku' => 'required',
            'produkDesc' => 'required',
            'haveExpired' => 'required',
            'satuan' => 'required',
            'qtyBalance' => 'required',
            'haveChild' => 'required',
            'qtyChild' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
        ]);

        Produk::create($data);
        return back();
    }

    public function edit(Produk $produk)
    {
        return view('produk.edit', compact('produk'));
    }

    public function show(Produk $produk)
    {
        return view('produk.show', compact('produk'));
    }

    public function update(Request $request, Produk $produk)
    {
        $data = $request->validate([
            'kodeProduk' => 'required',
            'nama' => 'required',
            'jenisProduk' => 'required',
            'sku' => 'required',
            'produkDesc' => 'required',
            'haveExpired' => 'required',
            'satuan' => 'required',
            'qtyBalance' => 'required',
            'haveChild' => 'required',
            'qtyChild' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
        ]);

        $produk->update($data);

        return back();
    }

    public function delete(Produk $produk)
    {
        $produk->delete();

        return back();
    }
}

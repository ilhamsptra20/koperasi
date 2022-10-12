<?php

namespace App\Http\Controllers;

use App\Models\VendorProduk;
use Illuminate\Http\Request;

class VendorProdukController extends Controller
{
    public function index()
    {
        $vendorProduk = VendorProduk::get();
        return view('vendorproduk', compact('vendorProduk'));
    }

    public function create()
    {
        return view('vendorproduk');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'idVendor' => 'required',
            'idProduct' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        VendorProduk::create($data);

        return back()->with('success', 'data berhasil ditambahkan');
    }

    public function show(VendorProduk $VendorProduk)
    {
        return view('vendorproduk', compact('vendorProduk'));
    }
    
    public function edit(VendorProduk $VendorProduk)
    {
        return view('vendorproduk', compact('vendorProduk'));
    }

    public function update(Request $request, VendorProduk $VendorProduk)
    {
        $data = $request->validate([
            'idVendor' => 'required',
            'idProduct' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
        ]);

        $VendorProduk->update($data);

        return back()->with('success', 'data berhasil diubah');
    }

    public function delete(VendorProduk $VendorProduk)
    {
        $VendorProduk->delete();
        return back()->with('success', 'data berhasil dihapus');
    }
}

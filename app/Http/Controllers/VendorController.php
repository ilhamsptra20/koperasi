<?php

namespace App\Http\Controllers;

use App\Models\Vendor;
use Illuminate\Http\Request;

class VendorController extends Controller
{
    public function index()
    {
        $vendor = Vendor::get();
        return view('vendor.', compact('vendor'));
    }

    public function create()
    {
        return view('vendor.');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nama' => 'required',
            'alamat' => 'required',
            'noHp' => 'required',
            'email' => 'required',
            'vendorDesc' => 'required',
            'filePhoto' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
            'modifiedBy' => 'required',
            'modifiedDate' => 'required',
        ]);

        Vendor::create($data);

        return back()->with('success', 'data berhasil ditambahkan');
    }

    public function show(Vendor $vendor)
    {
        return view('vendor.', compact('vendor'));
    }
    
    public function edit(Vendor $vendor)
    {
        return view('vendor.', compact('vendor'));
    }

    public function update(Request $request, Vendor $vendor)
    {
        $data = $request->validate([
            'nama' => 'required',
            'alamat' => 'required',
            'noHp' => 'required',
            'email' => 'required',
            'vendorDesc' => 'required',
            'filePhoto' => 'required',
            'catatan' => 'required',
            'fgActive' => 'required',
            'createdBy' => 'required',
            'createdDate' => 'required',
            'modifiedBy' => 'required',
            'modifiedDate' => 'required',
        ]);

        $vendor->update($data);

        return back()->with('success', 'data berhasil diubah');
    }

    public function delete(Vendor $vendor)
    {
        $vendor->delete();
        return back()->with('success', 'data berhasil dihapus');
    }
}


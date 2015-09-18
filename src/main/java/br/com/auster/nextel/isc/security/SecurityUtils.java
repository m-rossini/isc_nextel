/*
 * Copyright (c) 2004-2008 Auster Solutions. All Rights Reserved.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Created on 05/08/2008
 */
package br.com.auster.nextel.isc.security;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Properties;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.BasicConfigurator;

import br.com.auster.common.io.IOUtils;
import br.com.auster.common.io.NIOUtils;

/**
 * This class will be used to:
 *  1- generate new key files
 *  2- encrypt source files using specified key file
 *  3- decrypt source files using specified key file
 *
 * @author framos
 * @version $Id$
 *
 */
public class SecurityUtils {


	public static final int SECRET_KEY_MAX_LENGTH = 32;

	// actions
	public static final int GEN_KEYFILE = 0;
	public static final int ENCRYPT_SRC = 1;
	public static final int DECRYPT_DST = 2;

	// property tokens
	public static final String SECRETKEY_FILE = "isc.security.secretkey";
	public static final String ALGORITH_NAME = "isc.security.algorithm.name";
	public static final String ALGORITH_MODE = "isc.security.algorithm.mode";
	public static final String ALGORITH_PADDING = "isc.security.algorithm.padding";

	// exit codes
	public static final int ACTION_OK = 0;
	public static final int NOT_ALL_ARGS = 1;
	public static final int PROPERTIES_NOT_COMPLETE = 2;
	public static final int EXCEPTION_CAUGHT = 3;

	// command-line arguments
	public static final int ACTION_ARG = 0;
	public static final int SRCFILE_ARG = 1;
	public static final int DESTFILE_ARG = 2;
	public static final int KEYDESTFILE = 1;



	protected String algorithm;
	protected String secretKeyFile;



	/**
	 * @param args
	 */
	public static void main(String[] args) {

		// setting up log
		BasicConfigurator.configure();

		if (args.length < 2) {
			printUsage();
			System.exit(NOT_ALL_ARGS);
		}
		try {
			int action = Integer.parseInt(args[ACTION_ARG]);
			if (! SecurityUtils.isEnvironmentOk(action)) {
				printUsage();
				System.exit(PROPERTIES_NOT_COMPLETE);
			}
			// making sure GenerateKey action have an additional parameter
			if ((action != GEN_KEYFILE) && (args.length < 3)) {
				printUsage();
				System.exit(NOT_ALL_ARGS);
			}

			// running app
			SecurityUtils utils = new SecurityUtils();
			switch (action) {
				case GEN_KEYFILE: utils.generateKeyFile(args[KEYDESTFILE]); break;
				case ENCRYPT_SRC: utils.encryptFile(args[SRCFILE_ARG], args[DESTFILE_ARG]); break;
				case DECRYPT_DST: utils.decryptFile(args[SRCFILE_ARG], args[DESTFILE_ARG]); break;
				default: printUsage();
			}
			System.exit(ACTION_OK);
		} catch (Exception e) {
			e.printStackTrace();
			// TODO log
			System.exit(EXCEPTION_CAUGHT);
		}
	}

	public static boolean isEnvironmentOk(int _action) {
		Properties props = System.getProperties();
		if (props.containsKey(ALGORITH_NAME) &&
				props.containsKey(ALGORITH_MODE) &&
				props.containsKey(ALGORITH_PADDING)) {
			if(_action==GEN_KEYFILE) {
				return props.containsKey(SECRETKEY_FILE);
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	public static final String getSecreyKeyFile() { return System.getProperties().getProperty(SECRETKEY_FILE); }
	public static final String getAlgorithmName() { return System.getProperties().getProperty(ALGORITH_NAME); }
	public static final String getAlgorithmMode() { return System.getProperties().getProperty(ALGORITH_MODE); }
	public static final String getAlgorithmPadding() { return System.getProperties().getProperty(ALGORITH_PADDING); }

	public SecurityUtils() throws Exception { }



	/**
	 * Using {@param _output} as destination file, this method will create a secret key to be used
	 * 	when encrypting and decrypting password files.
	 *
	 * @param _output the name of the destination secret key file
	 *
	 * @throws IOException
	 * @throws NoSuchAlgorithmException
	 */
	public void generateKeyFile(String _output) throws IOException, NoSuchAlgorithmException {
	    int keyLength = 16; // 128 bits 'cause 192 and 256 may not be available...
		// Get the KeyGenerator
		//KeyGenerator kgen = KeyGenerator.getInstance(buildCypherAlgorithm());
		KeyGenerator kgen = KeyGenerator.getInstance("AES");
		kgen.init(keyLength * 8);
		// Generate the secret key specs.
		SecretKey skey = kgen.generateKey();
		byte[] rawKey = skey.getEncoded();
		OutputStream out = new FileOutputStream(_output);
	    out.write(rawKey);
	    out.close();
	}

	/**
	 * Encrypts the {@param _src} file into the {@param _dest} file.
	 *
	 * @param _src the unprotected file
	 * @param _dest encrypted version of {@param _src}
	 *
	 * @throws Exception
	 */
	public void encryptFile(String _src, String _dest) throws Exception {

		ReadableByteChannel source = null;
		OutputStream output = null;
		try {
		// open source file
		source = NIOUtils.openFileForRead(_src);

		// Create an 16-byte initialization vector
		byte[] iv = new byte[]
		{
			0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
		};

		AlgorithmParameterSpec paramSpec = new IvParameterSpec(iv);

	    // open destination file
	    output = IOUtils.openFileForWrite(new File(_dest), false);
	    // initialize the secret key
	    byte[] rawKey = this.readSecretKey();
	    String algorithm = String.valueOf(this.buildCypherAlgorithm());
	    SecretKeySpec secretKey = new SecretKeySpec(rawKey, System.getProperties().getProperty(ALGORITH_NAME));

	    // encrypting
	    Cipher cipher = Cipher.getInstance(buildCypherAlgorithm());
	    cipher.init(Cipher.ENCRYPT_MODE, secretKey, paramSpec);
	    output = new CipherOutputStream(output, cipher);

	    final int bufferSize = 16384;
	    NIOUtils.copyStream(source, Channels.newChannel(output), bufferSize);
		} finally {
			if (source != null) { source.close(); }
			if (output != null) { output.close(); }
		}
	}

	public void decryptFile(String _src, String _dest) throws Exception {
		WritableByteChannel output = null;
		try {
			// open destination file
			output = NIOUtils.openFileForWrite(new File(_dest), false);
			decryptFile(_src, output);

		} finally {
			if (output != null) { output.close(); }
		}
	}

	public void decryptFile(String _src, WritableByteChannel _dest) throws Exception {

		InputStream source = null;
		try {
			// Create an 16-byte initialization vector
			byte[] iv = new byte[]
			{
				0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
			};

			AlgorithmParameterSpec paramSpec = new IvParameterSpec(iv);

			// initialize the secret key
			byte[] rawKey = this.readSecretKey();
			String algorithm = String.valueOf(this.buildCypherAlgorithm());
			SecretKeySpec secretKey = new SecretKeySpec(rawKey, System.getProperties().getProperty(ALGORITH_NAME));
			// open source file
			source = IOUtils.openFileForRead(_src);
			// encrypting
			Cipher cipher = Cipher.getInstance(buildCypherAlgorithm());

			cipher.init(Cipher.DECRYPT_MODE, secretKey, paramSpec);
			source = new CipherInputStream(source, cipher);

			final int bufferSize = 16384;
			NIOUtils.copyStream(Channels.newChannel(source), _dest, bufferSize);
		} finally {
			if (source != null) { source.close(); }
		}

	}

	public static void printUsage() {
		System.out.println(" java SecurityUtils <action> <sourceFile> <destionationFile> " +
	     "\n" +
		 "\n Possible actions: " +
		 "\n  0 - Generate secret key file (GEN_KEYFILE) " +
		 "\n  1 - Encrypt source file into destination " +
		 "\n  2 - Decrypt source file into destination " +
		 "\n"+
		 "\n Needed to set the following system properties: " +
		 "\n  * isc.security.secretkey - path to secret key file (needed for actions 1 and 2 only) " +
		 "\n  * isc.security.algorithm.name - name of the algorithm (i.e: AES) " +
		 "\n  * isc.security.algorithm.mode - algoithm mode (i.e: CBC) " +
		 "\n  * isc.security.algorithm.padding - padding (i.e:  PKCS5Padding) ");
	}
	// Builds the algorithm string to get cipher instance
	protected String buildCypherAlgorithm() {
		Properties props = System.getProperties();
		StringBuilder cipherCfg = new StringBuilder();
		cipherCfg.append(props.getProperty(ALGORITH_NAME));
		cipherCfg.append("/");
		cipherCfg.append(props.getProperty(ALGORITH_MODE));
		cipherCfg.append("/");
		cipherCfg.append(props.getProperty(ALGORITH_PADDING));
		return cipherCfg.toString();
	}

	// reads the secret byte sequence from the key file
	protected byte[] readSecretKey() throws IOException {
	    final byte[] rawKeyBuffer = new byte[SECRET_KEY_MAX_LENGTH];
	    final InputStream in = new FileInputStream(getSecreyKeyFile());
	    // verify if we really found the file
	    if (in == null) {
	    	throw new FileNotFoundException(getSecreyKeyFile());
	    }
	    int size = 0, value = 0;
	    while ((value = in.read()) >= 0) {
	    	rawKeyBuffer[size] = (byte) value;
	    	size++;
	    	// check the file size (must not be greater thatn the rawKeyBuffer)
	    	if (size + 1 > SECRET_KEY_MAX_LENGTH) {
	    		throw new SecurityException("License file has an invalid key with length = [" + in.available() + "]");
	    	}
	    }
	    in.close();
	    // create the raw key from the buffer (compact the buffer)
	    final byte[] rawKey = new byte[size];
	    System.arraycopy(rawKeyBuffer, 0, rawKey, 0, size);
	    return rawKey;
	}

}
